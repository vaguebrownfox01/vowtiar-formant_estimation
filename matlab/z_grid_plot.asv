
formant_csv_path = "/home/jeevan/Jeevan_K/Projects/Vowtiar-Quest/vowtiar-formant_estimation/exports/e_synth-vowels_formant_estimation_vowlim100_fullwin.csv";
audio_data_path = "/home/jeevan/Jeevan_K/Projects/Vowtiar-Quest/vowtiar-formant_estimation/audio_exports/vowlim100/";


synth_formants = readtable(formant_csv_path);
l = size(synth_formants, 1);

res_errors = [];
formants_pred = [];
formants_truth = [];
index = [];
for n = 587:587
    aud_path = synth_formants{n, "synth_vowel_path"}{1};
    
    [fp, fn, ext] = fileparts(aud_path);
    
    i = synth_formants{n, "index"};
    base_formants = transpose(synth_formants{n, ["F1_mean_praat_base", "F2_mean_praat_base", "F3_mean_praat_base"]});
    
    vowel_path = audio_data_path + fn + ext;
    
    [x, Fs] = audioread(vowel_path);
    mid = 1.7/2;
    x = x((mid - 0.1) * Fs: (mid + 0.1) * Fs);
    [num, den] = rat(8000/Fs);
    x = resample(x, num, den);
%     x=[1 -1];
    x = x(1:250);
    Fs = 8000;
    NFFT = 256;
%     NFFT = 2^nextpow2(length(x));
    f = Fs/2*linspace(0,1,NFFT/2+1);

    x_vals = linspace(-2,2,50);
    y_vals = linspace(-2,2,50);
    z = [];
    Z = [];
    
    for i_x=1:length(x_vals)
        for i_y=1:length(y_vals)
            z_x = 0;
            z_y = 0;
            r = sqrt(x_vals(i_x)^2 + y_vals(i_y)^2);
            for i_aud=1:length(x)
%                 z_x = z_x + x(i_aud) * cos((i_aud) * atan2(y_vals(i_y),x_vals(i_x)))/(r^(i_aud));
%                 z_y = z_y - x(i_aud) * sin((i_aud) * atan2(y_vals(i_y),x_vals(i_x)))/(r^(i_aud));

                 z_x = z_x + x(i_aud) * cos((i_aud) * angle(1j*y_vals(i_y) + x_vals(i_x)))/(r^(i_aud));
                 z_y = z_y - x(i_aud) * sin((i_aud) * angle(1j*y_vals(i_y) + x_vals(i_x)))/(r^(i_aud));
            end
            z(i_x,i_y) = z_x + 1j*z_y;
          
        end
    end
    
    [X, Y] = meshgrid(x_vals, y_vals);
    surf(X,Y, log10(abs(z)))
    grid on;
end