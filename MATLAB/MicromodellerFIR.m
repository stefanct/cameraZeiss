clear
close all
%% ###########################################################
% The length, or number of taps of the filter
filter1.length=51; %Filter order
filter1.fs=30000; %Samplings frequency Hz
filter1.groupDelay=(filter1.length/2)/filter1.fs; %Group delay in sec.
filter1.fc1=300; %Frequency cut 1 (start of bandpass) Hz
filter1.fc2=6000; %Frequency cut 2 (end of bandpass) Hz
wc1 = (filter1.fc1/filter1.fs)*2;
wc2 = (filter1.fc2/filter1.fs)*2;

% The frequencies at the band edges
filter1.frequencies = [ 0, wc1, wc2, 1 ]; 
	
% The desired response
filter1.desired = [ 0, 1, 1, 0 ];

% Design the filter using the frequency sampling method with a Hamming window
%filter1.numerator = fir2( filter1.length-1, filter1.frequencies, filter1.desired, rectwin(filter1.length) ); % b coefficients
filter1.numerator = fir2( filter1.length-1, filter1.frequencies, filter1.desired, hamming(filter1.length) ); % b coefficients, hann, hamming, blackman
filter1.denominator = 1; % a coefficients


filter1.p_poles = roots( filter1.denominator );
filter1.z_zeros = roots( filter1.numerator );


%% ###########################################################
%# Filter analysis code
% Calculate the frequencies of interest      
filter1.frequencies = linspace( 0, 1, 512 );


% Calculate the complex frequency response      
filter1.cmplx = freqz( filter1.numerator, filter1.denominator, filter1.frequencies * pi );


% Calculate the magnitude of the frequency response
filter1.magnitude = abs( filter1.cmplx );


% Calculate the phase response      
filter1.phase = angle( filter1.cmplx );
% filter1.phase = unwrap( arg( filter1.cmplx ) );


% Calculate the group delay      
filter1.delay = grpdelay( filter1.numerator, filter1.denominator, filter1.frequencies );


% Calculate the impulse response      
filter1.impulse = filter( filter1.numerator, filter1.denominator, [1, zeros(1,127)] );


% Calculate the step response      
filter1.step = filter( filter1.numerator, filter1.denominator, ones(1,128) );


%% ###########################################################
%# Generate graphs
% The frequency vs magnitude graph
subplot( 3, 2, 1 );
plot( filter1.frequencies, 	filter1.magnitude );
xlabel('Normalized Frequency');
ylabel('Magnitude');
title( 'Magnitude' );
      
% The frequency vs phase graph
subplot( 3, 2, 3 );
plot( filter1.frequencies, 	unwrap( filter1.phase ) );
xlabel('Normalized Frequency');
ylabel('Phase');
title( 'Phase' );


% The frequency vs group delay graph
subplot( 3, 2, 5 );
plot( filter1.frequencies, 	filter1.delay );
title( 'Group Delay (samples)' );
xlabel('Normalized Frequency');
ylabel('Group Delay');
      
% The impulse response vs time graph
subplot( 3, 2, 2 );
stem( filter1.impulse );
title( 'Impulse Response' );
xlabel('Time (Samples)');
ylabel('Impulse Response');
      
subplot( 3, 2, 4 );
stem( filter1.step );     
title( 'Step Response' );
xlabel('Time (Samples)');
ylabel('Step Response');


% z-plane plot (poles and zeros)
subplot( 3, 2, 6 );
zplane( filter1.z_zeros, filter1.p_poles );
title( 'Poles and Zeros' );

%z-plane plot (Coefficients)
%figure
%zplane( filter1.numerator, filter1.denominator );

figure
b = filter1.numerator
stem(b);
title('FIR filter coefficients');
filter1
figure
freqz(filter1.numerator, filter1.denominator)
title('FIR frequency response');

%% Save coefficeints to header file
SaveFilterHeaderFile(b, filter1.fc1, 'FilterCoeffs_test.h');



