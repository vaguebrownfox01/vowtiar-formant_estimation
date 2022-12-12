formant_csv_path = "/home/jeevan/Jeevan_K/Projects/Asquire/Vowtiar-Quest/vowtiar-formant_estimation/exports/e_synth-vowels_formant_estimation_vowlim100_fullwin.csv";
audio_data_path = "/home/jeevan/Jeevan_K/Projects/Asquire/Vowtiar-Quest/vowtiar-formant_estimation/audio_exports/vowlim100/";


synth_formants = readtable(formant_csv_path);
l = size(synth_formants, 1);

res_errors = [];
formants_pred = [];
formants_truth = [];
index = [];
for n = 567:567
    n
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
%     NFFT = 2^nextpow2(length(x));
    NFFT = 256;
    f = Fs/2*linspace(0,1,NFFT/2+1);
    figure;
    for r_range=0.8:0.02:1.10
        CZT = czt(x,NFFT,exp(-2j*pi/NFFT),r_range);
        
%         y_ifft = ifft(CZT);
%         A = lpc(y_ifft, 8);
%         rts = roots(A);
% %         rts = rts(imag(rts)>=0);
% %         rts = rts(1:4);
%         [~, indices] = sort(imag(rts),"descend");
%         rts = rts(indices(1:4));
%         angz = atan2(imag(rts),real(rts));
%         [frqs,indices] = sort(angz.*(Fs/(2*pi)));
%         bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices)));
        
%         nn = 1;
%         formants = [];
%         for kk = 1:length(frqs)
%             if (frqs(kk) > 90 && bw(kk) <400)
%                 formants(nn) = frqs(kk);
%                 nn = nn+1;
%             end
%         end
%         formants(2:end)
%         r_range, frqs

%         plot(f,2*abs(CZT(1:NFFT/2+1)), 'DisplayName', num2str(r_range))
%         legend(num2str(r_range));
%         hold on;
        inp_i = 1:NFFT;
        x_val = r_range * cos(2*pi*inp_i/NFFT);
        y_val = - r_range * sin(2*pi*inp_i/NFFT);
        z_val = log10(abs(CZT));

        [X,Y] = meshgrid(x_val, y_val);

        Z = zeros(length(X), length(Y));
        for val_i=1:length(x_val)
                Z(val_i,val_i) = z_val(val_i) ;
           

        end


       
        mesh(X,Y,Z);
%         plot3(x_val, y_val, z_val, 'DisplayName',num2str(r_range));
        xlim([-1 1.5]);
        ylim([-1 1.5]);

        hold on;
        
        
%         x_circle = r_range * cos(2*pi.*f);
%         y_circle = r_range * sin(2*pi.*f);
%         z_circle = zeros(length(f));
%         plot3(x_circle, y_circle, z_circle, '-');
%         hold on;
%         
%         stem3(real(rts), imag(rts), max(z_val)*ones(length(rts)));

        grid
% 
%         index(n) = i;
%         formants_pred(n, :) = frqs(2:end);
%         formants_truth(n, :) = base_formants;
%     
%         error = (base_formants - frqs(2:end))';
%         res_errors(n, :) = error;
    end
    legend()

end