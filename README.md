# ECG Anomaly Detection Using Deep Learning

This repository contains the implementation of recurrent neural network (RNN) based deep learning architectures for detecting anomalies in ECG waveform and classifying normal and diseased condition.

## Abstract

<div align="justify"> Electrocardiogram (ECG) signals are the signals that represent the electrical conduction in the heart. It is taken with the help of electrodes which can detect the electrical potential caused due to the cardiac muscle depolarization and repolarization during each cardiac cycle. </div>

<div align="justify"> The beating of heart happens in a very systematic manner. Irregular beating of the heart is termed as arrhythmia, and are precursors to various cardiovascular diseases (CVDs). They are categorized into many groups or classes depending on the type and origin of the beat. Arrhythmias can talk about the condition of the heart, presence of any heart blocks or even can predict the chances of serious complications like myocardial infarction or stroke which might lead to death. Hence, detection and classification of arrhythmias is crucial for cardiac disease detection. Availability of an automatic ECG classification system will help medical professionals in diagnosis and to provide more effective and rapid treatments. </div>

<div align="justify"> In this project, an ensemble recurrent neural network model is proposed for classifying ECG signals into normal and abnormal. As the model might make errors while predicting noisy signals, a Naive bayes classifier iss used to separate out noisy and clean signals, and only clean signal is paased on to the deep learning model.
  
<div align="justify"> Finally, a graphical user interface (GUI) was designed to facilitate visualization, interpretation and real-time detection of cardiac diseases. </div>
  

## Dataset

The [PhysioNet Challenge 2017](https://physionet.org/content/challenge-2017/1.0.0/) dataset which consists of 8528 short single lead signals of 30-60 seconds length, sampled at 300 Hz was used to train our models. The signals in the dataset is categorised into normal sinus rhythm (N), atrial fibrillation (A), other rhythms (O) and noisy signals (~).

<img align="center" alt="Signal-types" width="800px" src="https://i.postimg.cc/C5CSZ9nG/Signal-Types.jpg" />
  
</br>


## Methods

The signals in a cell array, and their corresponding type in a categorical array, were saved in a .mat file.

It was observed that majority of the signals were 9000 samples long. So, all signals were processed to make them 9000 samples long to maintain uniformity and avoid excessive padding or truncating. 

A naive bayes classifier was constructed to separate clean signals from noisy ones, to save the deep learning models from incorrect interpretations. This method was used rather than using a filters because a wide range of noises may be present in the signals and designing filters for elimination of every possible type is not quite practical.


The following steps were applied before training the models:
- Data Augmentation: To tackle class imbalance
- Feature Extraction: Extraction of spectral and morphological features to obtain a greater classification performance
- Standardization using Z-scoring: To avoid unequal weighting of features 
- 80:20 train-test data split: For training and validation of the networks

Three RNN based architecures were used, which are:
- Long-Short Term Memory (LSTM)
- Bidirectional LSTM (BiLSTM)
- Gated Recurrent Units (GRU)

The model architectures are shown below.

<img align="center" alt="model-arch" width="800px" src="https://i.postimg.cc/wvCjRhfp/Capture2.jpg" />

</br>
</br>

The networks giving the maximum accuracies were saved and their prediction were merged into one. This method of creating an ensemble of neural networks helped to get a good overall accuracy in classification.

A GUI was created for visualization and analysis of the signals.

The GUI
- identifies the R peaks
- displays the amplitude values of R peaks
- displays the heart rate
- displays average RR interval
- displays heart rate variability
- displays NN50 value
- analyses the status of the rhythm and classifies it into normal, atrial fibrillation or other rhythms
- categorizes the condition of heart rate into normal, rapid (tachycardia) or slow (bradycardia)
- based on thecstatus of rhythm and the condition of heart rate, shows a suggestion about what should be done


## Results

Out of the three architectures, GRU gave the best classification accuracy. 

Merging of the models with high performance to make an ensemble neural network helped to improve the accuracy even more.

The model was incorporated into the GUI, and it was able to analyse the signals in >1 s, which shows that it can be used for real-time analysis.


<img align="center" alt="gui" width="800px" src="https://thumbs.gfycat.com/KnobbyAlienatedCottontail-max-1mb.gif" />



## References

- Mohebbanaaz, Y. P. Sai and L. V. R. kumari, "A Review on Arrhythmia Classification Using ECG Signals," 2020 IEEE International Students' Conference on Electrical, Electronics and Computer Science (SCEECS), 2020, pp. 1-6, doi: 10.1109/SCEECS48394.2020.9
- Saadatnejad, Saeed & Oveisi, Mohammadhosein & Hashemi, Matin. (2019). LSTM-Based ECG Classification for Continuous Monitoring on Personal Wearable Devices. IEEE Journal of Biomedical and Health Informatics. PP. 1-1. 10.1109/JBHI.2019.2911367. 
- Zhou, Zhi-Hua & Wu, Jianxin & Tang, Wei. (2002). Ensembling Neural Networks: Many Could Be Better Than All. Artificial Intelligence. 137. 239-263. 10.1016/S0004-3702(02)00190-X. 




