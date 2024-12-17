% Antenna Design Specifications
f0 = 2.4e9;            % Resonant Frequency (Hz)
c = 3e8;               % Speed of light (m/s)
epsilon_r = 4.4;       % Relative permittivity of the substrate (FR4)
h = 1.6e-3;            % Substrate thickness (m)

% Calculate Patch Dimensions
W = c / (2 * f0 * sqrt(epsilon_r));  % Patch Width
epsilon_eff = (epsilon_r + 1)/2 + (epsilon_r - 1)/2 * (1 + 12*h/W)^(-0.5);
delta_L = 0.412 * h * ((epsilon_eff + 0.3) * (W/h + 0.264)) / ((epsilon_eff - 0.258) * (W/h + 0.8));
L = c / (2 * f0 * sqrt(epsilon_eff)) - 2 * delta_L;  % Patch Length

% Ground Plane Dimensions
Lg = 6 * h + L;        % Ground Plane Length
Wg = 6 * h + W;        % Ground Plane Width


% Define the FR4 Substrate
substrate = dielectric('Name', 'FR4', ...
                       'EpsilonR', epsilon_r, ...
                       'LossTangent', 0.02, ...
                       'Thickness', h);
                       
% Create Patch Antenna with Substrate
patch = patchMicrostrip('Length', L, 'Width', W, ...
                        'GroundPlaneLength', Lg, 'GroundPlaneWidth', Wg, ...
                        'Substrate', substrate, ...
                        'FeedOffset', [L/4, 0]);  % Feed offset for impedance matching
% Visualize Antenna
show(patch);

% Frequency Range for Analysis
freqRange = linspace(2e9, 3e9, 201);  % Sweep from 2 GHz to 3 GHz

% Calculate S-parameters
s11 = sparameters(patch, freqRange);

% Plot S11
rfplot(s11, 1, 1);
title('S11 Reflection Coefficient');
grid on;

% Plot 3D Radiation Pattern at Resonant Frequency
figure;
pattern(patch, f0);
title('3D Radiation Pattern at 2.4 GHz');

% Calculate and Display Gain
gain = pattern(patch, f0, 0, 0);  % Gain in dB
disp(['Gain at boresight: ', num2str(gain), ' dB']);

% Plot Directivity
figure;
patternElevation(patch, f0);
title('Elevation Plane Directivity at 2.4 GHz');
