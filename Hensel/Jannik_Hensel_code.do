
clear
set more off
set matsize 800



//a)
gen havingkids = kidslt6 > 0

probit inlf nwifeinc educ exper expersq age
probit havingkids nwifeinc educ exper expersq age

//b)
biprobit (havingkids = nwifeinc educ exper expersq age ) (inlf = nwifeinc educ exper expersq age )

//c)
biprobit (inlf = havingkids nwifeinc educ exper expersq age ) (havingkids = nwifeinc educ exper expersq age ) 

//e) for significance at 5 % level
local iter=1

gen rho = 0
local rho = rho
constraint define 1 [athrho]_cons=`rho'
biprobit (havingkids = nwifeinc educ exper expersq age ) (inlf = havingkids nwifeinc educ exper expersq age ), constraint(1)
matrix b = e(b)
matrix v = e(V)
gen z = b[1,7]/(v[7,7]^(1/2))

while abs(z)> 1.64 {

replace rho = rho - 0.005
	local rho = rho
	display "iteration `iter'"
	local iter=`iter' + 1
	
constraint define 1 [athrho]_cons=`rho'
qui biprobit (havingkids = nwifeinc educ exper expersq age) (inlf = havingkids nwifeinc educ exper expersq age), constraint(1)
matrix b = e(b)
matrix v = e(V)
drop z
gen z = b[1,7]/(v[7,7]^(1/2))
sum z rho
di b[1,7]
}


//g)
biprobit (havingkids = nwifeinc educ exper expersq age ) (inlf = havingkids nwifeinc educ exper expersq age )
mkmat nwifeinc educ exper expersq age, matrix(X)
//matrix list x 
matrix b = e(b)
matrix beta = b[1, 1..5] 
matrix gamma = b[1, 8..12] 

matrix A = X*beta'
matrix B = X*gamma'

svmat A, names(A)
svmat B, names(B)

correlate A1 B1, covariance
replace rho = r(cov_12)/r(Var_2)
sum rho
local rho = rho
constraint define 1 [athrho]_cons=`rho'
biprobit (havingkids = nwifeinc educ exper expersq age ) (inlf = havingkids nwifeinc educ exper expersq age ), constraint(1)










