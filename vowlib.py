from tqdm import tqdm
from glob import glob
import pandas as pd
import numpy as np
import os
from os.path import basename as bn, join, split as sp

# Read paths
ROOT_TIMIT_DATA_PATH = "/home/jeevan/datasets/TIMIT Acoustic-Phonetic Continuous Speech Corpus (LDC93S1)/TIMIT"

# Write paths
ALL_EXP_FOLDER = "./exports/"
(lambda fp: os.mkdir(fp) if not os.path.exists(fp) else 0)(
    ALL_EXP_FOLDER
)  # make export folder

# Vowel info Export CSV filename
ALL_TIMIT_VOWELS_EXP_FILENAME = "a_all-timit_vowels.csv"
ALL_TIMIT_VOWELS_EXP_FILEPATH = join(ALL_EXP_FOLDER, ALL_TIMIT_VOWELS_EXP_FILENAME)
