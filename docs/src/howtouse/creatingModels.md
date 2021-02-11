# Creating structural models

The structural models are defined through a set of variables definitions in a .m script.

## Required variables

* `Nodes`: matrix with the coordinates of all the nodes. The $i$-th row contains the three coordinates of the node $i$: $[x_i , \, y_i ,\, z_i]$,
* `Conec`: cell structure with the connectivity information. The $\{i,1\}$ entry contains the vector with the MELCS (Material, Element, Load, CrossSection and Springs) indexes and the nodes of the $i$-th element.
The structure of the cell is:
```math
[ MaterialIndex, \, ElementIndex, \, LoadIndex, \, CrossSectionIndex, \, SpringIndex, \, Node_1 \dots Node_{n} ]
```
where the five indexes are natural numbers and $n$ is the number of nodes required by the type of element. If noproperty is assigned the $0$ index can be used. 
* `materialsParams`: a cell structure with a vector with the material properties of the $i$-th type of material in the $i$-th entry.
The vector of parameters is defined as:
```math
[ \rho, \, k_{thCo}, \, c_{spHe}, \, hyperModel  p_1 \dots p_{n_P} ]
```
where $k_{thCo}$ is the thermal conductivity (assuming thermal isotropy), $c_{spHe}$ is the specific heat, $n_P$ is the number of parameters of the constitutive model and $\mathbf{p}$ is the vector of constitutive parameters.
* `elementsParams`: cell structure with the element types information. Each different type of element corresponds to a different number. The properties of the element are in correspondency of the ElementIndex defined in the Conec cell structure. The structure of the cell is:
```math
[ elemType_{1}, \dots, elemType_{n} ] 
```
* `crossSecsParams`: cell structure with the information of the cross section parameters. The $\{i,1\}$ entry contains the vector with the paremeters in correspondency with the CrossSectionIndex defined in the Conec cell structure. 
The structure of the cell is:
```math
[crossSectionType, crossSectionParam_{1}, \dots, crossSectionParam_{n}]
```
With $n$ being the number of parameters of the cross section type.
* `springsParams`: cell structure with the information of the springs or supports in the structural model. The $\{i,1\}$ entry contains the vector with the paremeters in correspondency with the SpringIndex defined in the Conec cell structure. 
The structure of the cell is:
```math
[ u_x, \theta_x, u_y, \theta_y, u_z, \theta_z ]
```
where each entry of the $i$-th type corresponds with the spring stiffness. In casse of ideal supports, the stiffness shall be assigned as $+\infty$.
* `problemName`: string with the name of the problem, used to name folders and output files. 
* `dirOnsas`: array with the directory of the file `ONSAS.m`.

### Material parameters

* `Model 1`: Linear material with small strains (Saint-Venant-Kirchhoff).  
* `Model 2`: Linear material with Green Lagrange strains (Saint-Venant-Kirchhoff).  
* `Model 3`: Linear material with rotated engineering strains (Saint-Venant-Kirchhoff).  

### Elements params
  The `elementsParams` cell contains a vector in each entry. The first entry of each vector contains the type of element, for each type of element a different set of optional parameters can be included as other entries of the vector. These are the available types of elements:

1. Node: used to add loads or spring conditions.
1. Truss: the vector used for the truss element is:

   ```math 
   [ 2 \quad booleanConsistentMassMat ]
   ```

   Where `booleanConsistentMassMat` is a boolean that sets if the consistent or lumped form of the mass matrix is used.

1. Frame: the vector used for the frame element is:

   ``` math 
   [ 3 ]
   ```
   
   No additional parameter is needed for the frame element.
   
1. Tetrahedron: the vector used for the thetrahedron element is:

   ``` math 
   [ 4 \quad consMatFlag ] 
   ```
   
   Where `consMatFlag` is a parameter that allows the user to choose the method of computation the constitutive matrix. This parameter can take the values `1` and `2` corresponding to the computation of the constitutive matrix using the complex-step expression and analytical expression respectively.
   If the element is modeled as a Neo-Hookean compresible material, the value of the `consMatFlag` shall be 1. The default value is 2. 
   
1. Triangle: (used as faces to include boundary conditions) 

   ``` math 
   [ 5 ] 
   ```

### Loads params

Cell structure with a vector with parameters given by:

```math
[ global/local,\,  variable/constant,\,  f_x,\, m_x,\,  f_y,\, m_y,\,  f_z,\,  m_z,  q ]
```
where $q$ is an optional entry representing the input heat flow. In addition, the user can provide forces varying in time with the following optional variables:

* `loadFactorsFunc` (optional): function that defines forces applied on the structure variable in time. [default: t]
* `userLoadsFileName` (optional): filename of `.m` function file provided by the user that can be used to apply other forces varying.

### Cross-section parameters

1. General section:

   ```math
   [ 1,A,I_x,I_y,I_z,(J_x,J_y,J_z) ]
   ```
   
   Where $A$, $Ix$, $Iy$ and $Iz$ corresponds to the cross section area, the torsional stiffness and the bending stiffnesses respectively.

1. Rectangular cross section:

   ```math  
   [2,w_y,w_z]
   ```
   
   Where $w_y$ and $W_z$ corresponds to the dimension parallel to the $y$ and $z$ local axes respectively.

1. Solid circular cross section:
   
   ```math 
   [3,D]
   ```

## Optional variables

### General variables:

List of optional general variables:

* `reportBoolean`: boolean to set if LaTeX report is generated (1) or not (0). [default: 1] - currently not working
* `booleanScreenOutput`: boolean to set the output of the results on the command window. [default: 1]
* `storeBoolean`: boolean to store the results of the current iteration such as the displacements, tangent matrices, normal forces and stresses. [default: 1]
* `plotParamsVector`: array to set the type of output to visualize the results. [default: 1]
* `plotsViewAxis`: array to set the point of view of the Octave plots. [default: []]


### Modeling variables:

List of optional modelling variables:

* `booleanSelfWeightZ`: boolean to consider the selfweight of the elements in the analysis. [default: 0] 
* `stabilityAnalysisBoolean`: boolean to perform stability analysis compute eigenvalues of tangent matrix. [default: []]
* `nodalDisDamping`: scalar value of external viscous damping for displacements degrees of freedom [default: 0]
* `nonHomogeneousInitialCondU0`: matrix to set  the value of displacements at the time step $t$=0. [default: []]
* `nonHomogeneousInitialCondUdot0`: matrix to prescribe the value of velocities at the time step $t$=0. [default: []]
* `analyticSolFlag`: flag indicating if an analytical solution is provided, if so a function must be defined. [default: 0]
* `analyticCheckTolerance`: tolerance considered for the analytic verification. [default: 1e-8]
* `controlDofs: vector with information of the degree of freedom used to compare numerical vs analytical solution. [default: []]

$$
controlDofs = [ node nodaldof scalefactor ]
$$ 

with node being the node number, nodaldof being the local dof of the node (1 for x displacement, 2 for x angle ... 6), and scale factor being a scale factor to multiply the value before plotting.

* `numericalMethodParams`: array with parameters of the numerical method used to solve the equations. [default: []]

The structure of the array for the available numerical methods is:

```math
\left\{
\begin{array}{ccccccc}
[\; &0,\; &stopTolDeltau,\; &stopTolForces,\; &stopTolIts,\; &targetLoadFactr,\; &nLoadSteps,\; & ] \\
[\; &1,\; &stopTolDeltau,\; &stopTolForces,\; &stopTolIts,\; &targetLoadFactr,\; &nLoadSteps,\; & ] \\
[\; &2,\; &stopTolDeltau,\; &stopTolForces,\; &stopTolIts,\; &targetLoadFactr,\; &nLoadSteps,\; &incremArcLen ] \\
[\; &3,\; &deltaT,\; &finalTime,\; &stopTolDeltau,\; &stopTolForces,\; &stopTolIts,\; &deltaNW,\; &AlphaNW ] \\
[\; &4,\; &deltaT,\; &finalTime,\; &stopTolDeltau,\; &stopTolForces,\; &stopTolIts,\; &alphaHHT,\; & ] \\
\end{array}
\right\}
\begin{array}{ccccccc}
Linear\;static\;analysis \\
Non-Linear\;analysis\;Newton-Raphson \\
Non-Linear\;analysis\;Newton-Raphson\;Arc-Length \\
Dynamic\;analysis\;Newmark \\
Dynamic\;analysis\;HHT \\
\end{array}
```



### Analytical solution verification

The user can provide analytical solutions, which are automatically compared with the numerical solution provided by ONSAS. The solutions can be provided through different methods or formats, which are set by the variable __analyticSolFlag__. The formats of the solutions and the corresponding error measures used for the validation are:

* analyticSolFlag = 1: $u_{A,t}$ function of control displacement as a function of time is provided. In this case the error measure is calculated as 
```math
normRelativeError =\frac{1}{t_f} \left\| \frac{  u_{N,t} - u_{A,t}  }{ u_{A,t}  } \right\|_{L_1[0,t_f]} 
```
* analyticSolFlag = 2: in this case the user provides the function \verb|analyticFunc| with one argument $\lambda(u)$. This function computes the loadFactor as a function of the control displacement value. After the analysis and given an obtained numerical displacements history $u_{N,t}$, the analytical load factor history $\lambda(u_{N,t})$ is calculated and compared with the $\lambda_{N,t}$ values
```math
	normRelativeError = \frac{ \left\| \lambda( u_{N,t}) - \lambda_{N,t} \right\|_{L_1[0,t_f]} }{ \left\| \lambda_{N,t} \right\|_{L_1[0,t_f]}  }  
```




