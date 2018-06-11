%Assuming java can be executed from your command line (java.exe is in
%your system PATH). Update the folders below. For example:
%locate weka.jar in your file system and update the 1st folder
classifier = 'linearSVM';
switch classifier
    case 'linearSVM'
        !java -cp "C:\Program Files (x86)\Weka-3-7\weka.jar"  weka.classifiers.functions.SMO -t output\train.arff -T output\test.arff -o
    otherwise
        error('Invalid classifier!');
end