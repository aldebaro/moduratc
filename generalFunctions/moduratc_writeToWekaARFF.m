function writeToWekaARFF(fp_w,features,thisClassLabel)
[N,featuresDimension]=size(features);
for i =1:N    
    for j=1:featuresDimension
        %fprintf(fp_w, '%.20f,', features(i,j));
        fprintf(fp_w, '%e,', features(i,j));
    end
    %a=['This is a single quote '' and this is a double quote ".']
    fprintf(fp_w, '%s',['''' thisClassLabel '''']);
    fprintf(fp_w, '\n');    
end
