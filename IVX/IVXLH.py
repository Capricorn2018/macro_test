
# Based on the MATLAB Code provided by Kostakis(2015)
#
# Modification:
# 1. Adjust OLS estimation in accordance to K
# 2. Add IVX estimation of intercept for prediction purpose



#17 April 2018
#
#  Kostakis, A., Magdalinos, T., & Stamatogiannis, M. P. (2015),
#  Robust econometric inference for stock return predictability,
#  The Review of Financial Studies, 28(5), 1506-1553.
#
#  The function estimates the predictive regression
#  y{t}=mu+A*x{t-1}+e{t} (1),
#  and the VAR model
#  x{t}=R*x{t-1}+u{t}, with R being a diagonal matrix.
#
#
#INPUT:
#   yt: a Tx1 vector which is the precticted variable y{t}

#   xt: a Txk reg matrix including the regressors as columns.
#
#   The program automatically includes an intercept in the predictive
#   regression, so there is no need for a column of 1's.
#   There is no need to input the lagged series; the program lags the series.
#
#   K: is the horizon (special case K=1 corresponds to a short-horizon
#      regression)
#
#   print_res: set print_res=1 if you want the results to be printed;

#OUTPUT:
#   Aols: a (kreg+1)x1 vector which is the OLS estimator of the intercept mu
#         (1st element) and the slope coefficients (A)
#
#   Aivx: a 1xkreg vector which is the IVX estimator of A in (1)
#
#   Wivx : is a 2x1 vector with the first element being the Wald statistic of
#          a test for overall sifnificance, whereas the second gives the corresponding p-value (from the
#          chi-square distribution)
#
#   WivxInd: is a 2xkreg matrix
#           the first row gives the individual test of siginificance for each
#           predictor (i.e. restricting each predictor's coefficient to be equal to
#           0 letting the rest coefficients free to be estimated),
#           whereas the second row gives the corresponding p-values (for a two-sided test).
#
#   Q is the variance-covariance matrix of the IVX estimator for A.
#
#   res_corrmat gives the correlation between the residuals of the predictive
#           regression (e{t}) and the residuals of the autoregressive part (u{t})

import numpy as np
import statsmodels.api as sm
from scipy.stats import chi2



def ivxlh(yt,xt,K,print_res=0):
# yt and xt are both numpy arrays
# NOTE that yt and xt are contemporary variables !!!!!

    # covert xt to two-dimensional array for convenience
    if len(xt.shape)== 1:
       xt = xt.reshape((len(xt),1))

    m = xt.shape[0]
    xt_mean = xt[0:m-K+1,:].mean(axis =0 )

    xlag = xt[0:-1,:]
    xt = xt[1:,:]
    y = yt[1:]

    nn, L = xlag.shape
    X = np.hstack((np.ones((nn,1)),xlag))

    Wivx = np.zeros(2)
    WivxInd = np.zeros((2, L))

    # predictive regression residual estimation
    md = sm.OLS(y, X)
    res = md.fit()

    #Aols = res.params
    epshat = res.resid

    rn = np.zeros((L,L))
    for i in range(L):
        md_1 = sm.OLS(xt[:,i],xlag[:,i])
        res_1 = md_1.fit()
        rn[i,i] = res_1.params

    # autoregressive residual estimation
    u = xt - xlag.dot(rn)

    # residuals correlation matrix
    res_corrmat = np.corrcoef(np.hstack((epshat.reshape((len(epshat),1)),u)).T)


    # covariance matrix estimation(predictive regression)
    covepshat = epshat.dot(epshat)/nn
    covu = np.zeros((L,L))
    if len(u.shape) == 1:
       u = u.reshape((len(u),1))
    for t in range(nn):
        covu = covu + u[t:t+1,:].T.dot(u[t:t+1,:])


    #covariance matrix estimation (autoregression)
    covu=covu/nn
    covuhat=np.zeros((1,L))
    for j in range(L):
        covuhat[0,j] = np.sum(epshat*u[:,j])


    # covariance matrix between 'epshat' and 'u'
    covuhat = covuhat.T/nn

    m = int(np.floor(np.power(nn,1/3)))
    uu = np.zeros((L,L))
    for h in range(m):
        a = np.zeros((L,L))
        for s in range(nn-h-1):
            t = s + h + 1
            a = a + u[t:t+1,:].T.dot(u[t-h-1:t-h,:])
        uu = uu + (1-(h+1)/(1+m))*a

    uu = uu/nn
    Omegauu = covu + uu + uu.T

    q = np.zeros((m,L))
    for h in range(m):
        p = np.zeros((nn-h,L))
        for t in range(nn-h-1):
            t = t + h + 1
            p[t-h,:] = u[t,:]*epshat[t-h -1]
        q[h,:] = (1-(h+1)/(1+m))*p.sum(axis=0)

    residue = q.sum(axis=0)/nn
    Omegaeu = covuhat +residue.reshape((len(residue),1))


    # instrument construction
    n = nn - K + 1
    Rz = (1-1/np.power(nn,0.95))*np.eye(L)
    diffx = xt - xlag
    z = np.zeros((nn,L))
    z[0,:] = diffx[0,:]
    for i in range(nn-1):
        i = i+1
        z[i,:] = z[i-1:i,:].dot(Rz)+diffx[i,:]

    Z = np.vstack((np.zeros((1,L)),z[0:n-1,:]))

    zz = np.vstack((np.zeros((1,L)),z[0:nn-1,:]))

    ZK = np.zeros((n,L))
    for i in range(n):
        ZK[i,:] = zz[i:i+K,:].sum(axis=0)

    yy = np.zeros((n,1))
    for i in range(n):
        yy[i] = y[i:i+K].sum()

    if K == 1:
       md =  sm.OLS(yy, X)
    else:
       md = sm.OLS(yy, X[0:-K+1,:])
    res = md.fit()

    Aols = res.params
    Apval = res.pvalues



    xK = np.zeros((n,L))
    for i in range(n):
        xK[i,:] = xlag[i:i+K,:].sum(axis=0)

    meanxK = xK.mean(axis=0)
    Yt = yy - yy.mean()
    Xt = np.zeros((n,L))
    for j in range(L):
        Xt[:,j] = xK[:,j] - meanxK[j]*np.ones(n)


    Aivx = np.matmul(Yt.T.dot(Z),np.linalg.pinv(Xt.T.dot(Z)))
    meanzK = ZK.mean(axis=0)
    meanzK = meanzK.reshape((1,len(meanzK)))

    FM = covepshat - Omegaeu.T.dot(np.linalg.inv(Omegauu)).dot(Omegaeu)
    M = ZK.T.dot(ZK)*covepshat - n*meanzK.T.dot(meanzK)*FM

    H = np.eye(L)
    aa = H.dot(np.linalg.pinv(Z.T.dot(Xt))).dot(M)
    bb = np.linalg.pinv(Xt.T.dot(Z)).dot(H.T)
    Q = aa.dot(bb)

    Wivx[0] = H.dot(Aivx.T).T.dot(np.linalg.pinv(Q)).dot(H).dot(Aivx.T)
    Wivx[1] = 1 - chi2.cdf(Wivx[0],L)

    WivxInd[0,:] = Aivx/np.sqrt(np.diag(Q)).T
    WivxInd[1,:] = 1 - chi2.cdf(np.power(WivxInd[0,:],2),1)

    # IVX estimator of Intercept
    mu_ivx = yy.mean() - Aivx.dot(xt_mean)


    if print_res == 1:
        print('Horizon: ')
        print(K)
        print('       ')

        print('IVX estimator of mu: ')
        print(mu_ivx)
        print('     ')

        print('IVX estimator of A: ')
        print(Aivx)
        print('       ')

        print('Individual Tests of Significance:(pValues)')
        print(WivxInd[1,:])
        print('     ')

        print('Test of Overall Model Significance:(pValues)')
        print(Wivx[1])
        print('     ')

        print('OLS estimator of coefficient')
        print(Aols)
        print('     ')

        print('Standard t-test of OLS estimator Significannce(pValues):')
        print(Apval)
        print('     ')

        print('Residuals Correlation Matrix')
        print(res_corrmat)
        print('       ')


    return mu_ivx, Aivx, WivxInd, Wivx, res_corrmat, Aols, Apval














































