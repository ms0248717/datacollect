# datacollect

* **Training Data Synthesis**
    * MATLAB code
    * Gen_main_2.m: generate moving detection model training data
	    * Output file: ML_data/{train_label_2.csv, train_phase_2.csv, train_rssi_2.csv, train_distance_2.csv, test_label_2.csv, test_phase_2.csv, test_rssi_2.csv, test_distance_2.csv}
    * Gem_main_dis.m: generate gesture recognition model training data
        * Output file: ML_data/{train_label.csv, train_phase.csv, train_rssi.csv, train_distance.csv, test_label.csv, test_phase.csv, test_rssi.csv, test_distance.csv}

---
* **Real Trajectory Collection**
    * Swift code
    * CoreMotion-master/DeviceMotionData.xcodeproj
	    * Output file: data.csv
  	    * Use AirDrop to share to computer
	    * Gesture data: Trajectory/*

---
* **Model Training**
    * Python code
    * ML/train_cnn_2.py: training moving detection model
	    * The best model: ML/bestmodel/C2_15_10_2.h5
    * ML/train_cnn.py: training gesture recognition model
	    * The best model: ML/bestmodel/C4_30_10_90r_0r432_3.h5

---
* **Reader Control Code**
    * C# code
    * reader_data/ReaderConnectivity/ReaderConnectivity/1_ReaderConnectivity.csproj
	    * Collect reader data

---
* **Reader Data Processing**
    * MATLAB code
    * reader_data/Pairtag_cal.m: pairing calculation
    * reader_data/N_Pairtag_cal_dis.m: skip the pairing step
	    * Output file: reader_data/ML_realdata/*

---
* **Reader Data Gesture Recognition**
    * Pythone code
    * ML/test_readerdata_2.py: testing moving detection model
    * ML/test_readerdata.py: testing gesture recognition model
	    * Output recognition accuracy 

---
