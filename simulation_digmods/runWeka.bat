REM locate weka.jar in your file system and update the folder below
java -cp "C:\Program Files (x86)\Weka-3-6\weka.jar" weka.classifiers.functions.SMO -t output\amqam_train.arff -T output\amqam_test.arff -o -k
