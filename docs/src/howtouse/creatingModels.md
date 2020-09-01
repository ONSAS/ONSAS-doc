# Creating structural models

The structural models are defined through a set of variables definitions in a .m script.

## Required variables


* Nodes: matrix with coordinates
* Conec: cell structure with the connectivity


* materialsParams: a cell structure with a vector with the material parameters of the $i$-th type of material in the $i$-th entry.
The vector of parameters is defined as:
```math
[ \rho, \, k_{thCo}, \, c_{spHe}, \, hyperModel  p_1 \dots p_{n_P} ]
```
where $k_{thCo}$ is the thermal conductivity (assuming thermal isotropy), $c_{spHe}$ is the specific heat, $n_P$ is the number of parameters of the constitutive model and $\mathbf{p}$ is the vector of constitutive parameters.
* elementsParams: a cell structure,	
* crossSecsParams:

### Material parameters

Model 1: linear elastic small strains.

### Cross-section parameters

  1. general: [ 1 A Ix Iy Iz (Jx Jy Jz)]
  1. rectangular: [2 $w_y$ $w_z$ ]
  1. circular: [3 $D$], with $D$ being the diameter of the section

### Elements params
1. node (used to add loads or spring conditions)
1. truss
1. frame
1. tetrahedron


## Optional variables

* reportBoolean: boolean to set if LaTeX report is generated (1) or not (0) [default: 1]
* analyticSolFlag: flag indicating if an analytical solution is provided, if so a function must be defined.
* __analyticCheckTolerance__: tolerance considered for the analytic verification default: 1e-8.


###  Analytical solution verification

The user can provide analytical solutions, which are automatically compared with the numerical solution provided by ONSAS. The solutions can be provided through different methods or formats, which are set by the variable __analyticSolFlag__. The formats of the solutions and the corresponding error measures used for the validation are:

* analyticSolFlag = 1: $u_{A,t}$ function of control displacement as a function of time is provided. In this case the error measure is calculated as 
```math
normRelativeError =\frac{1}{t_f} \left\| \frac{  u_{N,t} - u_{A,t}  }{ u_{A,t}  } \right\|_{L_1[0,t_f]} 
```
* analyticSolFlag = 2: in this case the user provides the function \verb|analyticFunc| with one argument $\lambda(u)$. This function computes the loadFactor as a function of the control displacement value. After the analysis and given an obtained numerical displacements history $u_{N,t}$, the analytical load factor history $\lambda(u_{N,t})$ is calculated and compared with the $\lambda_{N,t}$ values
```math
	normRelativeError = \frac{ \left\| \lambda( u_{N,t}) - \lambda_{N,t} \right\|_{L_1[0,t_f]} }{ \left\| \lambda_{N,t} \right\|_{L_1[0,t_f]}  }  
```
