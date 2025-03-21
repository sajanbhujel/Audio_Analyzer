classdef AudioAnalyzerApp < matlab.apps.AppBase

    properties (Access = public)
        UIFigure        matlab.ui.Figure
        RecordButton    matlab.ui.control.Button
        WaveformAxes    matlab.ui.control.UIAxes
        SpectrumAxes    matlab.ui.control.UIAxes
        FreqLabel       matlab.ui.control.Label
        TitleLabel      matlab.ui.control.Label
    end

    methods (Access = private)
        
        function recordAudio(app)
            fs = 44100;  
            duration = 5;  
            nBits = 16;  
            nChannels = 1; 

            recorder = audiorecorder(fs, nBits, nChannels);
            
            app.RecordButton.Text = 'Recording...';
            app.RecordButton.BackgroundColor = [1 0.5 0.5]; 
            drawnow; 
            recordblocking(recorder, duration);
            app.RecordButton.Text = 'Start Recording';
            app.RecordButton.BackgroundColor = [0.47 0.67 0.19];

            audioData = getaudiodata(recorder); 

            t = linspace(0, duration, length(audioData));
            plot(app.WaveformAxes, t, audioData, 'b', 'LineWidth', 1.2);
            xlabel(app.WaveformAxes, 'Time (seconds)');
            ylabel(app.WaveformAxes, 'Amplitude');
            title(app.WaveformAxes, 'Recorded Audio Waveform');
            grid(app.WaveformAxes, 'on');

            n = length(audioData);
            fTransform = abs(fft(audioData));
            f = (0:n-1) * (fs/n);

            [~, index] = max(fTransform(1:floor(n/2)));
            dominantFreq = f(index);

            plot(app.SpectrumAxes, f(1:floor(n/2)), fTransform(1:floor(n/2)), 'r', 'LineWidth', 1.2);
            xlabel(app.SpectrumAxes, 'Frequency (Hz)');
            ylabel(app.SpectrumAxes, 'Magnitude');
            title(app.SpectrumAxes, 'Frequency Spectrum');
            grid(app.SpectrumAxes, 'on');

            app.FreqLabel.Text = sprintf('Dominant Frequency: %.2f Hz', dominantFreq);
            app.FreqLabel.Position = [150 40 300 30];
            app.FreqLabel.FontSize = 16;
            app.FreqLabel.FontColor = [0 0.5 0];
        end
    end

    methods (Access = private)

        function RecordButtonPushed(app, ~, ~)
            recordAudio(app);
        end
    end

    methods (Access = public)

        function app = AudioAnalyzerApp()
    
            createComponents(app);
        end
    end

    methods (Access = private)

        function createComponents(app)
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 600 500];
            app.UIFigure.Name = 'Audio Analyzer App';
            app.UIFigure.Color = [0.9 0.9 0.9];

            app.TitleLabel = uilabel(app.UIFigure);
            app.TitleLabel.Position = [150 450 300 30];
            app.TitleLabel.Text = 'Audio Frequency Analyzer';
            app.TitleLabel.FontSize = 18;
            app.TitleLabel.FontWeight = 'bold';
            app.TitleLabel.HorizontalAlignment = 'center';

            app.RecordButton = uibutton(app.UIFigure, 'push');
            app.RecordButton.Position = [230 390 140 40];
            app.RecordButton.Text = 'Start Recording';
            app.RecordButton.FontSize = 14;
            app.RecordButton.FontWeight = 'bold';
            app.RecordButton.BackgroundColor = [0.47 0.67 0.19];
            app.RecordButton.ButtonPushedFcn = @(~,~) app.RecordButtonPushed();

            app.WaveformAxes = uiaxes(app.UIFigure);
            app.WaveformAxes.Position = [50 250 500 120];
            title(app.WaveformAxes, 'Waveform');
            grid(app.WaveformAxes, 'on');

            app.SpectrumAxes = uiaxes(app.UIFigure);
            app.SpectrumAxes.Position = [50 100 500 120];
            title(app.SpectrumAxes, 'Frequency Spectrum');
            grid(app.SpectrumAxes, 'on');

            app.FreqLabel = uilabel(app.UIFigure);
            app.FreqLabel.Position = [150 40 300 30];
            app.FreqLabel.Text = 'Dominant Frequency: -- Hz';
            app.FreqLabel.FontSize = 16;
            app.FreqLabel.FontWeight = 'bold';
            app.FreqLabel.HorizontalAlignment = 'center';
        end
    end
end
