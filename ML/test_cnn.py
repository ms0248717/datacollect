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

def feature_normalize(dataset):

    mu = np.mean(dataset, axis=0)
    sigma = np.std(dataset, axis=0)
    return (dataset - mu)/sigma

def show_confusion_matrix(validations, predictions):

    matrix = metrics.confusion_matrix(validations, predictions)
    plt.figure(figsize=(6, 4))
    sns.heatmap(matrix,
                cmap="coolwarm",
                linecolor='white',
                linewidths=1,
                xticklabels=LABELS,
                yticklabels=LABELS,
                annot=True,
                fmt="d")
    plt.title("Confusion Matrix")
    plt.ylabel("True Label")
    plt.xlabel("Predicted Label")
    plt.show()

def read_data(file_path):
    df = pd.read_csv(file_path)
    return df

weight_load = 0
weight_save = 0
model_save = 0
store = 1
high_acc = 0
LABELS = ["0","1"]

trainlabel = read_data('../ML_data/train_label.csv')
trainphase = read_data('../ML_data/train_phase.csv')
trainrssi = read_data('../ML_data/train_rssi.csv')
testlabel = read_data('../ML_data/test_label.csv')
testphase = read_data('../ML_data/test_phase.csv')
testrssi = read_data('../ML_data/test_rssi.csv')
#Y_trainlabel_df = pd.DataFrame(trainlabel)

Y_trainlabel = np.asarray(trainlabel)
X_trainphase = np.asarray(trainphase, dtype= np.float32)
X_trainrssi = np.asarray(trainrssi, dtype= np.float32)
Y_testlabel = np.asarray(testlabel)
X_testphase = np.asarray(testphase, dtype= np.float32)
X_testrssi = np.asarray(testrssi, dtype= np.float32)

Y_train = Y_trainlabel.T
Y_test = Y_testlabel.T
#print(Y_train.shape)

trainsize = Y_train.shape[0]
X_train_A = []
for i in range(0, trainsize):
    A = np.hstack((X_trainphase[:,i][:,np.newaxis], X_trainrssi[:,i][:,np.newaxis]))
    if i == 0:
        X_train_A = A
    else:
        X_train_A = np.concatenate((X_train_A, A))
X_train = np.asarray(np.vsplit(X_train_A, trainsize))

testsize = Y_test.shape[0]
X_test_A = []
for i in range(0, testsize):
    A = np.hstack((X_testphase[:,i][:,np.newaxis], X_testrssi[:,i][:,np.newaxis]))
    if i == 0:
        X_test_A = A
    else:
        X_test_A = np.concatenate((X_test_A, A))
X_test = np.asarray(np.vsplit(X_test_A, testsize))
#print(X_test.shape)

###################################
# %%

print("\n--- Reshape data to be accepted by Keras ---\n")
x_train = X_train
y_train = Y_train
# Inspect x data
print('x_train shape: ', x_train.shape)
# Displays (20869, 40, 3)
print(x_train.shape[0], 'training samples')
# Displays 20869 train samples

# Inspect y data
print('y_train shape: ', y_train.shape)
# Displays (20869,)

# Set input & output dimensions
num_time_periods, num_sensors = x_train.shape[1], x_train.shape[2]
num_classes = 2

# Set input_shape / reshape for Keras
# Remark: acceleration data is concatenated in one array in order to feed
# it properly into coreml later, the preferred matrix of shape [40,3]
# cannot be read in with the current version of coreml (see also reshape
# layer as the first layer in the keras model)
input_shape = (num_time_periods*num_sensors)
x_train = x_train.reshape(x_train.shape[0], input_shape)

print('x_train shape:', x_train.shape)
# x_train shape: (20869, 120)
print('input_shape:', input_shape)
# input_shape: (120)

# Convert type for Keras otherwise Keras cannot process the data
x_train = x_train.astype("float32")
y_train = y_train.astype("float32")

# %%

# One-hot encoding of y_train labels (only execute once!)
y_train = np_utils.to_categorical(y_train, num_classes)
print('New y_train shape: ', y_train.shape)
# (4173, 6)

# %%
model = load_model('./bestmodel/C1_0.05.h5')

x_test = X_test
y_test = Y_test

x_test = x_test.reshape(x_test.shape[0], input_shape)

x_test = x_test.astype("float32")
y_test = y_test.astype("float32")

y_test = np_utils.to_categorical(y_test, num_classes)

score = model.evaluate(x_train, y_train, verbose=1)

print("\nAccuracy on test data: %0.2f" % score[1])
print("\nLoss on test data: %0.2f" % score[0])

# %%

print("\n--- Confusion matrix for test data ---\n")

y_pred_test = model.predict(x_test)
# Take the class with the highest probability from the test predictions
max_y_pred_test = np.argmax(y_pred_test, axis=1)
max_y_test = np.argmax(y_test, axis=1)

show_confusion_matrix(max_y_test, max_y_pred_test)

# %%

print("\n--- Classification report for test data ---\n")

print(classification_report(max_y_test, max_y_pred_test))