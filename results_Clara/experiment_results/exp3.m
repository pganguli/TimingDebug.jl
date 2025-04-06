% Create the system model
A = [0    1         0
     0   -0.0227   54.5455
     0  -34.2857  -70];
B = [ 0
      0
     28.1754];
C = [1  0  0];

% Preallocate result array
start_h_max = 5;  % periods 0.005:0.005:0.025
pole_max = 8;     % pole positions 0.2:0.1:0.9
h_max = 196;      % periods up to 200
result = repmat(...
    struct(...
        'stable', 0, ...
        'poles', [0 0 0 0], ...
        'poledist', 0, ...
        'dompoledist', 0, ...
        'rise', 0, ...
        'settling', 0, ...
        'overshoot', 0), ...
    start_h_max, pole_max, h_max);

% For each period
for start_h_idx = 1:start_h_max
    start_h = 0.005 * start_h_idx;
    % Create the augmented system model for this period
    [phi_a, Gamma_a, C_a] = augmented_model(A, B, C, start_h, start_h);
    
    % For each pole position
    for pole_idx = 1:pole_max
        pole_pos = 0.1 + 0.1*pole_idx;
        % Make the reference controller
        poles = repmat([pole_pos], 1, size(phi_a, 1));
        [K, F, ~] = poleplacement(phi_a, Gamma_a, C_a, poles);
        result(start_h_idx, pole_idx, 1).stable = 1;
        result(start_h_idx, pole_idx, 1).poles = poles;
        % Run the reference controller
        [st, mi, S] = simulate1_new(A, B, C, start_h, start_h, K, F);
        result(start_h_idx, pole_idx, 1).rise = S.RiseTime;
        result(start_h_idx, pole_idx, 1).settling = S.SettlingTime;
        result(start_h_idx, pole_idx, 1).overshoot = S.Overshoot;
        
        % For every period up to 200 ms
        for h_idx = 2:196
            h = start_h + 0.001 * (h_idx - 1);
            % Compute the poles of the system when run with a longer period
            [phi_ai,Gamma_ai,C_ai] = augmented_model(A,B,C,h,h);
            sysd=ss(phi_ai-Gamma_ai*K,Gamma_ai*F,C_a,0,h);
            iter_poles = sort(pole(sysd).', 2, 'descend', 'ComparisonMethod', 'abs');
            % If the system is not stable, break
            if any(abs(iter_poles) >= 1)
                break
            end
            result(start_h_idx, pole_idx, h_idx).stable = 1;
            result(start_h_idx, pole_idx, h_idx).poles = iter_poles;
            result(start_h_idx, pole_idx, h_idx).poledist = sum(abs(poles - iter_poles));
            result(start_h_idx, pole_idx, h_idx).dompoledist = abs(abs(poles(1)) - abs(iter_poles(1)));
            % Run the controller
            [st, mi, S] = simulate1_new(A, B, C, h, h, K, F);
            result(start_h_idx, pole_idx, h_idx).rise = S.RiseTime;
            result(start_h_idx, pole_idx, h_idx).settling = S.SettlingTime;
            result(start_h_idx, pole_idx, h_idx).overshoot = S.Overshoot;
        end
        
        % Calculate pole displacements
        %poles = sort(poles, 2, 'descend', 'ComparisonMethod', 'abs');
        %displ = mean(abs(poles(1,:) - poles), 2);
        %displ_dom = abs(poles(1,1) - poles(:,1));
    end
end