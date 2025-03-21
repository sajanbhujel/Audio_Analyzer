fs = 44100;  
duration = 5; 
nBits = 16;
nChannels = 1; 

recorder = audiorecorder(fs, nBits, nChannels);

disp('Recording... Speak now or play the tone generator.');
recordblocking(recorder, duration);
disp('Recording stopped.');

audioData = getaudiodata(recorder); 

t = linspace(0, duration, length(audioData));
figure;
subplot(2,1,1);
plot(t, audioData);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Recorded Audio Waveform');

n = length(audioData);
fTransform = abs(fft(audioData));
f = (0:n-1) * (fs/n);

[~, index] = max(fTransform(1:floor(n/2)));
dominantFreq = f(index);

subplot(2,1,2);
plot(f(1:floor(n/2)), fTransform(1:floor(n/2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum of Recorded Audio');

disp(['Dominant Frequency Detected: ', num2str(dominantFreq), ' Hz']);
