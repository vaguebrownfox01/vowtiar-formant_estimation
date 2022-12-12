formant_csv_path = "/home/jeevan/Jeevan_K/Projects/Asquire/Vowtiar-Quest/vowtiar-formant_estimation/exports/e_synth-vowels_formant_estimation_vowlim100_fullwin.csv";
audio_data_path = "/home/jeevan/Jeevan_K/Projects/Asquire/Vowtiar-Quest/vowtiar-formant_estimation/audio_exports/vowlim100/";


synth_formants = readtable(formant_csv_path);
l = size(synth_formants, 1);

res_errors = [];
formants_pred = [];
formants_truth = [];
index = [];
for n = 567:567
    aud_path = synth_formants{n, "synth_vowel_path"}{1};
    
    [fp, fn, ext] = fileparts(aud_path);
    
    i = synth_formants{n, "index"};
    base_formants = transpose(synth_formants{n, ["F1_mean_praat_base", "F2_mean_praat_base", "F3_mean_praat_base"]});
    
    vowel_path = audio_data_path + fn + ext;
    
    [x, Fs] = audioread(vowel_path);
    mid = 1.7/2;
    x = x((mid - 0.5) * Fs: (mid + 0.5) * Fs);
    [num, den] = rat(8000/Fs);
    x = resample(x, num, den);
    
    Fs = 8000;
    NFFT = 256;
%     NFFT = 2^nextpow2(length(x));
    f = Fs/2*linspace(0,1,NFFT/2+1);
    figure;

%     r = input("Enter r")
%     x_val = linspace(-2,2,50);
%     y_val = linspace(-2,2,50);
%     z_val = [];
%     for x_ind=1:length(x_val)
%         for y_ind=1:length(y_val)
%           z_x = 0;
%           z_y = 0;
%           for x_i=1:length(x)
%             z_x = z_x + x(x_i) * cos((x_i-1)*atan(y_val(y_ind)/x_val(x_ind)))/(r^(x_i-1));
%         
%             z_y = z_y - x(x_i) * sin((x_i-1)*atan(y_val(y_ind)/x_val(x_ind)))/(r^(x_i-1));
%           end
%           z_val(x_ind, y_ind) = z_x + 1j*z_y;
%           
% 
% 
% 
%         end
%     end
%         
        
    r = linspace(1.01,1.1,100);
    theta = linspace(1,NFFT,NFFT);
    theta = theta./NFFT;
    z = [];

        for i_theta=1:length(theta)
            z_x = 0;
            z_y = 0;
           for x_i=1:length(x)
            z_x = z_x + x(x_i) * cos(2*pi*theta(i_theta)*(x_i-1))/(r^(x_i-1));
%         
            z_y = z_y - x(x_i) * sin(2*pi*theta(i_theta)*(x_i-1))/(r^(x_i-1));
           end 
           z(i_theta, i_r) = z_x + 1j*z_y;
        end

    end
    
    [X,Y] = meshgrid(r, theta);
%         z_val = log10(abs(z_val));

%     Z = zeros(length(X), length(Y));
   
    surf(X, Y, log10(abs(z)));
   

   
%          mesh(X,Y,Z);
%    xlim([-1 2.5]);
%    ylim([-1 2.5]);
   hold on;

end
