audio_path = "/home/jeevan/Jeevan_K/Projects/Asquire/Vowtiar-Quest/vowtiar-formant_estimation/audio_exports/vowlim100/";
export_audio_path = "/home/jeevan/Jeevan_K/Projects/Asquire/Vowtiar-Quest/vowtiar-formant_estimation/audio_exports/vowlim100_filt/";
audio_files = dir(audio_path);
 
%%
 
for i = 3:3 %length(audio_files)
    
    [x, Fs] = audioread(audio_path + "iy_23_MMVP0_M_114.wav");
    [num den] = rat(8000/Fs);
    x = resample(x, num, den);
    
    Fs = 8000;
    NFFT = 2^nextpow2(length(x));
    f = Fs/2*linspace(0,1,NFFT/2+1);
     
    FFT = fft(x,NFFT);
    FFT = (FFT-mean(FFT))/std(FFT);
     
     
    CZT = czt(x,NFFT,exp(-2j*pi/NFFT),1.05);
%     CZT = (CZT-mean(CZT))/std(CZT);
     
    % X = ifft(CZT(1:NFFT/2+1), length(x));
    % X = (X-mean(X))/std(X);
     
    diff_sec = diff(abs(CZT),1);
     
    sign_array = sign(diff_sec(1:length(diff_sec)-1))- sign(diff_sec(2:length(diff_sec)));
     
    indexes = find(sign_array((1:NFFT/2+1))>0);
     
    
    peak_freqs = f(indexes);
    amps = abs(CZT(1:NFFT/2+1));
    peak_amps = amps(indexes);
    
    % mat_filename = strrep(audio_files(i).name, ".wav", ".mat");
    % 
    % save("exports/" + mat_filename, 'peak_freqs', 'peak_amps')
     
    
%     y = zeros(length(x),1);
%     for j=1:length(peak_freqs)
%         if peak_freqs(j) < 5000
%             f1 = (peak_freqs(j)-20)*(2/Fs);
%             f2 = (peak_freqs(j)+20)*(2/Fs);
%             [b,a] = cheby2(4,1,[f1 f2], "bandpass");
%             filt_op = filter(b,a,x);
%             y = y + filt_op;
%             
% 
%         end
%   
%     
%     end
%     
%     
%     
% 
% %     audiowrite(export_audio_path + "iy_197_FLAG0_F_198.wav",y,Fs);
% 
%     fft2 = fft(y,NFFT)/length(y);
%     y = (y - min(y))/(max(y) - min(y));
%     
%     figure
%      
%     subplot(1,2,1) 
%     plot(f,2*abs(CZT(1:NFFT/2+1)))
%     hold on;
%     subplot(1,2,2)
%     plot(f,2*abs(fft2(1:NFFT/2+1)))
    


    y_ifft = ifft(CZT);
%     plot(real(y_ifft(1:200)))
    A = lpc(y_ifft, 8);
    rts = roots(A);
    rts = rts(imag(rts)>=0);
    angz = atan2(imag(rts),real(rts));
    [frqs,indices] = sort(angz.*(Fs/(2*pi)));
    bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices)));

    nn = 1;
    formants = []
    for kk = 1:length(frqs)
        if (frqs(kk) > 90 && bw(kk) <100)
            formants(nn) = frqs(kk);
            nn = nn+1;
        end
    end
    formants
        

     
%     figure
%      
%     subplot(1,2,1);
%     plot(f,2*abs(FFT(1:NFFT/2+1)))
%      
%     subplot(1,2,2)
%     plot(f,sign_array(1:NFFT/2+1))
%     %  
%      figure
%      plot(y)
     
    % audiowrite("czt_denoised_output/" + audio_files(i).name, abs(X), Fs)
    %
    % phase=atan2(imag(CZT),real(CZT))*180/pi;
    % w = 2*pi*f;
    %
    %
    % diff_ph = -diff(phase,1)./(2*pi*f(2:length(f)));
    %
    %
    %
    % figure
    % Y = fft(y,NFFT)/length(x);
    % plot(f,2*abs(Y(1:NFFT/2+1)))
    %
    % figure;
    % subplot(1,2,1);
    % plot(f,2*abs(CZT(1:NFFT/2+1)))
    %
    % subplot(1,2,2);
    % plot(f,diff_ph(1:NFFT/2+1))
     
     
     
    % plot(f,2*abs(Y(1:NFFT/2+1)))
     
end