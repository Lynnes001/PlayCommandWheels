# SR tools

import difflib, librosa
import numpy as np
from scipy.io import wavfile
import Levenshtein
import speech_recognition as sr

def GoogleSR(wavFile, transcipt=''):
    r = sr.Recognizer()
    with sr.AudioFile(wavFile) as source:
    
#         r.adjust_for_ambient_noise(source)
        

        audio = r.record(source)  # read the entire audio file
    try:
        # gspeech: output of GoogleSR

        gspeech = r.recognize_google(audio);
#         pprint(sr.recognize_google(audio, show_all=True))  # pretty-print the recognition result
        # deleter upper case character and ',', '.'
        gspeech = gspeech.lower().replace(',','').replace('.','');

        score = string_similar(gspeech, transcipt)
        return([score, gspeech, wavFile])

    except sr.UnknownValueError:
        return([-1, "Google Speech Recognition could not understand audio", wavFile])

    except sr.RequestError as e:
        return([-1, "Could not request results from Google Speech Recognition service; {0}".format(e), wavFile])
        
        
# def GoogleSR(signal, fs, transcipt=''):
    # r = sr.Recognizer()
    # audio = sr.AudioData(signal, fs, 2)
    # try:
        # # gspeech: output of GoogleSR

        # gspeech = r.recognize_google(audio);
# #         pprint(sr.recognize_google(audio, show_all=True))  # pretty-print the recognition result
        # # deleter upper case character and ',', '.'
        # gspeech = gspeech.lower().replace(',','').replace('.','');

        # score = string_similar(gspeech, transcipt)
        # return([score, gspeech])

    # except sr.UnknownValueError:
        # return([-1, "Google Speech Recognition could not understand audio"])

    # except sr.RequestError as e:
        # return([-1, "Could not request results from Google Speech Recognition service; {0}".format(e), ])
    
def string_similar(s1, s2):
#     return difflib.SequenceMatcher(None, s1, s2, autojunk=True).ratio()
    return Levenshtein.ratio(s1, s2) 
