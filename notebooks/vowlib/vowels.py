import os

# Read paths
ROOT_TIMIT_DATA_PATH = "/home/jeevan/datasets/TIMIT Acoustic-Phonetic Continuous Speech Corpus (LDC93S1)/TIMIT"

# Write paths
ALL_EXP_FOLDER = "../exports/"

# Audio Export folder
AUDIO_EXP_FOLDER = "../audio_exports"

# Utils
mkdir = lambda fp: os.mkdir(fp) if not os.path.exists(fp) else 0

# TIMIT SAMPLING RATE
TIMIT_AUDIO_FS = 16000

# Numbers Vowel
VOWEL_LIMIT = 100

# TIMIT VOWEL INFO
TIMIT_VOWEL_INFO = """  iy         beet          bcl b IY tcl t
                        ih         bit           bcl b IH tcl t 
                        eh         bet           bcl b EH tcl t
                        ey         bait          bcl b EY tcl t
                        ae         bat           bcl b AE tcl t
                        aa         bott          bcl b AA tcl t
                        aw         bout          bcl b AW tcl t
                        ay         bite          bcl b AY tcl t
                        ah         but           bcl b AH tcl t
                        ao         bought        bcl b AO tcl t
                        oy         boy           bcl b OY
                        ow         boat          bcl b OW tcl t
                        uh         book          bcl b UH kcl k
                        uw         boot          bcl b UW tcl t
                        ux         toot          tcl t UX tcl t
                        er         bird          bcl b ER dcl d
                        ax         about         AX bcl b aw tcl t
                        ix         debit         dcl d eh bcl b IX tcl t
                        axr        butter        bcl b ah dx AXR
                        ax-h       suspect       s AX-H s pcl p eh kcl k tcl t"""


def get_vowels():
    timit_vowels = TIMIT_VOWEL_INFO.split("\n")
    ALL_TIMIT_VOWEL_LIST = [" ".join(x.split()).split(" ")[0] for x in timit_vowels]
    return ALL_TIMIT_VOWEL_LIST
