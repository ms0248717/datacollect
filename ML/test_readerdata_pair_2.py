from __future__ import print_function
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
from scipy import stats

from sklearn import metrics
from sklearn.metrics import classification_report
from sklearn import preprocessing

import keras
from keras.models import Sequential, load_model
from keras.layers import Dense, Dropout, Flatten, Reshape, GlobalAveragePooling1D
from keras.layers import Conv2D, MaxPooling2D, Conv1D, MaxPooling1D
from keras.utils import np_utils


def feature_normalize_p(dataset):

    mu = np.mean(dataset, axis=0)
    sigma = np.std(dataset, axis=0)
    for i in range(0, dataset.shape[1]):
        if sigma[i] == 0:
            sigma[i] = 1
    return (dataset - mu)


def feature_normalize_r(dataset):

    mu = np.mean(dataset, axis=0)
    sigma = np.std(dataset, axis=0)
    for i in range(0, dataset.shape[1]):
        if sigma[i] == 0:
            sigma[i] = 1
    return (dataset - mu)


def read_data(file_path):
    df = pd.read_csv(file_path)
    return df


LABELS = ["line", "shake", "square", "circle", "still"]
DIS = ["50", "100", "150"]
result = [0, 0]
resultN = [0, 0]
LABEL = ["move", "still"]
SIZE = ["2", "4", "6", "8", "10", "12", "14"]

model = load_model('./bestmodel/C2_15_10_2.h5')
ACC = 0

for tagsize in range(0, 7):
    ACC = 0
    for lab in range(0, 5):
        # print(LABELS[lab])
        result = [0, 0]

        for j in range(1, 11):

            #phase = read_data('../reader_data/ML_realdata/phase_'+'line'+'_0_50_' + str(j) + '.csv')
            #rssi = read_data('../reader_data/ML_realdata/rssi_'+'line'+'_0_50_' + str(j) + '.csv')
            phase = read_data('../reader_data/ML_realdata/gc_tagsize/phase_' +
                            LABELS[lab] + '_' + SIZE[tagsize] + '_1_' + str(j) + '.csv')
            rssi = read_data('../reader_data/ML_realdata/gc_tagsize/rssi_' +
                            LABELS[lab] + '_' + SIZE[tagsize] + '_1_' + str(j) + '.csv')

            X_phase = np.asarray(phase, dtype=np.float32)
            X_rssi = np.asarray(rssi, dtype=np.float32)

            X_phase = feature_normalize_p(X_phase)
            X_rssi = feature_normalize_r(X_rssi)

            size = X_phase.shape[1]

            X_test_A = []
            for i in range(0, size):
                A = np.hstack((X_phase[:, i][:, np.newaxis],
                            X_rssi[:, i][:, np.newaxis]))
                if i == 0:
                    X_test_A = A
                else:
                    X_test_A = np.concatenate((X_test_A, A))
            X_test = np.asarray(np.vsplit(X_test_A, size))

            # Set input & output dimensions
            num_time_periods, num_sensors = X_test.shape[1], X_test.shape[2]
            num_classes = 2

            # Set input_shape / reshape for Keras
            # Remark: acceleration data is concatenated in one array in order to feed
            # it properly into coreml later, the preferred matrix of shape [40,3]
            # cannot be read in with the current version of coreml (see also reshape
            # layer as the first layer in the keras model)
            input_shape = (num_time_periods*num_sensors)

            # print('input_shape:', input_shape)

            x_test = X_test

            x_test = x_test.reshape(x_test.shape[0], input_shape)

            x_test = x_test.astype("float32")

            # print('test after load: ', model.predict(x_test))
            y_pred_test = model.predict(x_test)
            # Take the class with the highest probability from the test predictions
            sum_y_pred_test = y_pred_test[0] + y_pred_test[1]
            max_y_pred_test = np.argmax(sum_y_pred_test, axis=1)
            # print(size)
            resultN = [0, 0, 0, 0]
            # for i in range(0, size):
            resultN[max_y_pred_test[0]] = resultN[max_y_pred_test[0]] + 1
            # print(resultN)
            # print(resultN.index(max(resultN)))
            result[resultN.index(max(resultN))
                ] = result[resultN.index(max(resultN))] + 1

        if lab == 4:
            ACC = ACC + result[1]
        else:
            ACC = ACC + result[0]
        result[0] = round(result[0]/10.0, 3)
        result[1] = round(result[1]/10.0, 3)
        # print(result)
    print(SIZE[tagsize])
    print(ACC / 50.0)