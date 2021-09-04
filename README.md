# ECG Anomaly Detection Using Deep Learning

This repository contains the implementation of recurrent neural network based deep learning architectures for detecting anomalies in ECG waveform and classifying normal and diseased condition.

## Abstract

<div style="text-align: justify"> Electrocardiogram (ECG) signals are the signals that represent the electrical conduction in the heart. It is taken with the help of electrodes which can detect the electrical potential caused due to the cardiac muscle depolarization and repolarization during each cardiac cycle. </div>

The beating of heart happens in a very systematic manner. Irregular beating of the heart is termed as arrhythmia, and are precursors to various cardiovascular diseases (CVDs). They are categorized into many groups or classes depending on the type and origin of the beat. Arrhythmias can talk about the condition of the heart, presence of any heart blocks or even can predict the chances of serious complications like myocardial infarction or stroke which might lead to death. Hence, detection and classification of arrhythmias is crucial for cardiac disease detection. Availability of an automatic ECG classification system will help medical professionals in diagnosis and to provide more effective and rapid treatments.

In this project, an ensemble recurrent neural network model is proposed for classifying ECG signals into normal and abnormal. As the model might make errors while predicting noisy signals, a Naive bayes classifier iss used to separate out noisy and clean signals, and only clean signal is paased on to the deep learning model. 
Finally, a graphical user interface (GUI) was designed to facilitate visualization, interpretation and real-time detection of cardiac diseases.
  



## Dataset

We used [PhysioNet Challenge 2017](https://physionet.org/content/challenge-2017/1.0.0/) dataset which consists of 8528 short single lead signals of 30-60 seconds length, sampled at 300 Hz to train our model, which classifies ECG signals into normal sinus rhythm (N), atrial fibrillation (A) and other rhythms (O).

</br>

[![Signal-Types.jpg](https://i.postimg.cc/C5CSZ9nG/Signal-Types.jpg)](https://postimg.cc/YLSJZn30)

## Methods

## Results

## References



[![Capture2.jpg](https://i.postimg.cc/wvCjRhfp/Capture2.jpg)](https://postimg.cc/hz0BH7Ry)


[![Capture.jpg](https://i.postimg.cc/434ZY8Xt/Capture.jpg)](https://postimg.cc/YvPTVzGq)

![ecg](https://user-images.githubusercontent.com/73361480/131980725-589d3226-626c-41aa-b1f8-ce53117c56ed.gif)
