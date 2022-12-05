# modules
import numpy as np
import os

import librosa
import parselmouth
from parselmouth.praat import call
from scipy.io.wavfile import write

import praat_formants_python as pfp


def measure_pitch(audio_path: str) -> float:
    """
    Measure Pitch using Parsel Mouth, Praat

    audio_path

    ...

    return: mean_pitch
    """
    f0min, f0max = [75, 600]

    sound = parselmouth.Sound(audio_path)  # read the sound
    pitch = call(sound, "To Pitch", 0, f0min, f0max)  # create a praat pitch object
    mean_pitch = call(pitch, "Get mean", 0, 0, "Hertz")  # get mean pitch

    return mean_pitch


def measure_formants_pfp(audio_path: str, start_sec: float, end_sec: float) -> list:
    """
    Calculate formants using pfp, Praat

    audio_path
    start_sec
    end_sec

    ...

    return:
        mean_pitch,
        f1_mean, f2_mean, f3_mean,
        f1_median, f2_median, f3_median
    """
    formants = pfp.formants_at_interval(
        audio_path, start_sec, end_sec, maxformant=5500, winlen=0.5, preemph=50
    )

    mean_pitch = measure_pitch(audio_path)
    mean_pitch = np.round(mean_pitch, 2)

    formants_mean = formants.mean(axis=0)
    formants_mean = list(formants_mean)[1:]  # skip time
    formants_mean = np.round(formants_mean, 2)  # round

    formants_median = np.median(formants, axis=0)
    formants_median = list(formants_median)[1:]  # skip time
    formants_median = np.round(formants_median, 2)  # round

    return (
        mean_pitch,
        formants_mean[0],
        formants_mean[1],
        formants_mean[2],
        formants_median[0],
        formants_median[1],
        formants_median[2],
    )


def measure_formants_psm(
    audio_path: str, vowel_name: str, start_sec: float, end_sec: float
) -> list:
    """
    Calculate formants using Parsel Mouth, Praat

    audio_path
    vowel_name
    start_sec
    end_sec
    ...

    return: [
        mean_pitch,
        f1_mean, f2_mean, f3_mean, f4_mean,
        f1_median, f2_median, f3_median, f4_median
    ]
    """
    f0min, f0max = [75, 600]
    sound = parselmouth.Sound(audio_path)  # read the sound
    # pitch = call(sound, "To Pitch (cc)", 0, f0min, 15, 'no', 0.03, 0.45, 0.01, 0.35, 0.14, f0max)
    pitch = call(sound, "To Pitch", 0.0001, f0min, f0max)
    mean_pitch = call(pitch, "Get mean", 0, 0, "Hertz")  # get mean pitch

    audio_chunk, fs = librosa.load(
        audio_path, sr=None, offset=start_sec, duration=(end_sec - start_sec)
    )

    TEMP_AUDIO_EXP_FOLDER = "./tmp_psm/"
    (lambda fp: os.mkdir(fp) if not os.path.exists(fp) else 0)(TEMP_AUDIO_EXP_FOLDER)
    tmp_audio_file = os.path.join(TEMP_AUDIO_EXP_FOLDER, f"{vowel_name}.wav")
    write(tmp_audio_file, fs, audio_chunk)
    sound_frm = parselmouth.Sound(tmp_audio_file)
    # sound_frm = sound_frm.extract_part(rom_time=start_sec, to_time=end_sec, window_shape=0, relative_width=1, preserve_times=False) # read the sound chunk
    pointProcess = call(sound_frm, "To PointProcess (periodic, cc)", f0min, f0max)
    formants = call(sound_frm, "To Formant (burg)", 0.0025, 5, 5000, 0.025, 50)
    numPoints = call(pointProcess, "Get number of points")

    f1_list = []
    f2_list = []
    f3_list = []
    f4_list = []

    # Measure formants only at glottal pulses
    for point in range(0, numPoints):
        point += 1
        t = call(pointProcess, "Get time from index", point)
        f1 = call(formants, "Get value at time", 1, t, "Hertz", "Linear")
        f2 = call(formants, "Get value at time", 2, t, "Hertz", "Linear")
        f3 = call(formants, "Get value at time", 3, t, "Hertz", "Linear")
        f4 = call(formants, "Get value at time", 4, t, "Hertz", "Linear")
        f1_list.append(f1)
        f2_list.append(f2)
        f3_list.append(f3)
        f4_list.append(f4)

    f1_list = [f1 for f1 in f1_list if str(f1) != "nan"]
    f2_list = [f2 for f2 in f2_list if str(f2) != "nan"]
    f3_list = [f3 for f3 in f3_list if str(f3) != "nan"]
    f4_list = [f4 for f4 in f4_list if str(f4) != "nan"]

    # calculate mean formants across pulses
    f1_mean = np.mean(f1_list)
    f2_mean = np.mean(f2_list)
    f3_mean = np.mean(f3_list)
    f4_mean = np.mean(f4_list)

    # calculate median formants across pulses, this is what is used in all subsequent calcualtions
    # you can use mean if you want, just edit the code in the boxes below to replace median with mean
    f1_median = np.median(f1_list)
    f2_median = np.median(f2_list)
    f3_median = np.median(f3_list)
    f4_median = np.median(f4_list)

    os.remove(tmp_audio_file)

    return [
        mean_pitch,
        f1_mean,
        f2_mean,
        f3_mean,
        f4_mean,
        f1_median,
        f2_median,
        f3_median,
        f4_median,
    ]
