clc
addpath(genpath('../Toolboxes'));

%TemporalConcat
type = 'typical'
sigma = 1.5
Group_TemporalConcat(type,sigma)
sigma = 0.5
Group_TemporalConcat(type,sigma)
type = 'dyslexic'
Group_TemporalConcat(type,sigma)


%meanEigen
type = 'typical'
Group_meanEigen(type)
type = 'dyslexic'
Group_meanEigen(type)




