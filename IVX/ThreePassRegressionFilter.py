import statsmodels.api as sm
import numpy as np


def Est3PRF(Y, X, Z):
# Three Pass Regression Filter based on Kelly & Pruitt(2015)
# Y is T * 1 dimensional Array, independent variable
# X is T * N array, predictors
# Z is T * M array, proxies

    if len(Y.shape) == 1:
        Y = np.reshape(Y, (len(Y), 1))
    if len(X.shape) == 1:
        X = np.reshape(X, (len(X), 1))
    if len(Z.shape) == 1:
        Z = np.reshape(Z, (len(Z), 1))

    T = Y.shape[0]
    N = X.shape[1]
    M = Z.shape[1]

    J_T = np.diag(np.ones(T)) - np.ones((T,T))/T

    PHI = (np.linalg.inv(Z.T.dot(J_T).dot(Z)).dot(Z.T).dot(J_T).dot(X)).T

    J_N = np.diag(np.ones(N)) - np.ones((N, N))/N

    # %% estimated latent factor
    F_coeff = np.linalg.inv(PHI.T.dot(J_N).dot(PHI)).dot(PHI.T).dot(J_N)
    F = (F_coeff.dot(X.T)).T

    # beta = np.linalg.inv(F.T.dot(J_T).dot(F)).dot(F.T).dot(J_T).dot(Y)
    md_ols = sm.OLS(Y, sm.add_constant(F))
    res = md_ols.fit()

    md_stats = {'FittedValues': res.fittedvalues, \
                'F_coeff': F_coeff, \
                'F': F, \
                'PHI': PHI, \
                'BETA': res.params}

    return md_stats


def Pred3PRF(X_new, md_stats):

# X_new is T_new * N array, predictors
# md _stats is get from Est3PRF
    if len(X_new.shape) == 1:
        X_new = np.reshape(X_new, (1, len(X_new)))

    T_new, N = X_new.shape
    PHI = md_stats['PHI']
    BETA = md_stats['BETA']

    J_N = np.diag(np.ones(N)) - np.ones((N, N))/N

    F_new = (np.linalg.inv(PHI.T.dot(J_N).dot(PHI)).dot(PHI.T).dot(J_N).dot(X_new.T)).T

    Y_new = BETA[0] + F_new.dot(BETA[1:])

    return Y_new

























