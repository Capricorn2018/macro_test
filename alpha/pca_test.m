function param = pca_test(x,n,m)
% ��pca������x��ά, ��ʼ�뷨��x��ÿһ����һ����������
% n�����Ҫ�õ���������, �����������֮��40���¿�ʼ
% m�ǹ������ڳ���, ����40����

    param = nan(size(x));
    
    if(istable(x))
        x = table2array(x);
    end

    for i = n:size(x,1)
        coeff = pca(x((i-m+1):i,:));
        param(i,:) = coeff(:,1)';
    end

end

