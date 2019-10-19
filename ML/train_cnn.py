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
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, Reshape, GlobalAveragePooling1D
from keras.layers import Conv2D, MaxPooling2D, Conv1D, MaxPooling1D
from keras.utils import np_utils

def feature_normalize(dataset):

    mu = np.mean(dataset, axis=0)
    sigma = np.std(dataset, axis=0)
    return (dataset - mu)/sigma

def read_data(file_path):
    df = pd.read_csv(file_path)
    return df

weight_load = 0
weight_save = 0
model_save = 0
store = 1
high_acc = 0

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

Y_trainlabel = Y_trainlabel.T
Y_testlabel = Y_testlabel.T
print(Y_trainlabel.shape)

trainsize = Y_trainlabel.shape[0]
X_train_A = []
for i in range(0, trainsize):
    A = np.hstack((X_trainphase[:,i][:,np.newaxis], X_trainrssi[:,i][:,np.newaxis]))
    if i == 0:
        X_train_A = A
    else:
        X_train_A = np.concatenate((X_train_A, A))
X_train = np.asarray(np.vsplit(X_train_A, trainsize))
print(X_train.shape)

testsize = Y_testlabel.shape[0]
X_test_A = []
for i in range(0, testsize):
    A = np.hstack((X_testphase[:,i][:,np.newaxis], X_testrssi[:,i][:,np.newaxis]))
    if i == 0:
        X_test_A = A
    else:
        X_test_A = np.concatenate((X_test_A, A))
X_test = np.asarray(np.vsplit(X_test_A, testsize))
print(X_test.shape)

###################################
num_samples, num_mode = X_train.shape[1], X_train.shape[2]

X_train = X_train.astype("float32")
X_test = X_test.astype("float32")
Y_train = Y_train.astype("float32")
Y_test = Y_test.astype("float32")

Y_train = keras.utils.to_categorical(Y_train)
Y_test = keras.utils.to_categorical(Y_test)

## Train model setting
# 1D CNN neural network
model_m = Sequential(name='ini_weight')
model_m.add(Conv1D(100, 10, activation='relu', input_shape=(num_samples, num_mode))) # 200 20
model_m.add(Conv1D(100, 10, activation='relu')) # 150 10 best for two
model_m.add(MaxPooling1D(3))
model_m.add(Conv1D(160, 10, activation='relu')) # 220 10 for two200 10
model_m.add(Conv1D(160, 10, activation='relu'))
model_m.add(GlobalAveragePooling1D())
model_m.add(Dropout(0.5))
#model_m.add(Dense(60, activation='softmax'))
#model_m.add(Dense(20, activation='softmax'))
model_m.add(Dense(3, activation='softmax',name='fin_weight'))
print(model_m.summary())
if weight_load:
    model_m.load_weights('phase_weight.h5', by_name = True)
callbacks_list = [
    #keras.callbacks.ModelCheckpoint(
    #   filepath='best_model.{epoch:02d}-{val_loss:.2f}.h5',
    #   monitor='val_loss', save_best_only=True),
    keras.callbacks.EarlyStopping(monitor='loss', patience=5)
]
model_m.compile(loss='categorical_crossentropy',
                optimizer='adam', metrics=['accuracy'])

# Hyper-parameters
BATCH_SIZE = 400 # 200
EPOCHS = 50 # 70
print(X_train.shape)
# Enable validation to use ModelCheckpoint and EarlyStopping callbacks.
history = model_m.fit(X_train,
                    Y_trainlabel,
                    batch_size=BATCH_SIZE,
                    epochs=EPOCHS,
                    callbacks=callbacks_list,
                    validation_split=0.1,
                    verbose=1)
print(history.history['accuracy'])
score = model_m.evaluate(X_test, Y_testlabel, verbose=1)

print("\nAccuracy on test data: %0.2f" % score[1])
print("\nLoss on test data: %0.2f" % score[0])
if score[1] > high_acc:
    high_acc = score[1]
    store = 1
else:
    store = 0

y_pred_test = model_m.predict(X_test)
# Take the class with the highest probability from the test predictions
max_y_pred_test = np.argmax(y_pred_test, axis=1)
max_y_test = np.argmax(Y_testlabel, axis=1)
#print (y_pred_test)
# saved the model
if model_save and store:
    model_m.save('AoA_model'+str(cnt[gg])+'lrr.h5')
# save the weight with name
if weight_save and store:
    model_m.save_weights('aoa_weight'+str(cnt[gg])+'lrr.h5')
#high_rec[0,gg] = high_acc
print (high_acc)
