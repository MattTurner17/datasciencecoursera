## Overall, these two functions acting together allow efficient computation
## of the inverse of a matrix (assuming the the matrix provided is invertible).
## It is efficient because if the inverse has already been calculated, 
## then that value is cached and can be recalled without needing to 
## calculate again.


## The makeCacheMatrix function is adding the getinverse and setinverse
## properties to the matrix x. This is so that they can then be used in
## the cacheSolve function to check whether an inverse has already been
## calculated for the given matrix.
makeCacheMatrix <- function(x = matrix()) {
     i <- NULL
     set <- function(y) {
          x <<- y
          i <<- NULL
     }
     get <- function() x
     setinverse <- function(solve) i <<- solve
     getinverse <- function() i
     list(set = set, get = get,
          setinverse = setinverse,
          getinverse = getinverse)
}


## The cacheSolve function is checking to see whether the inverse of x has  
## already been calculated and set.
## If it has been calculated then the cached answer is returned, avoiding
## unnecessary calculations. Otherwise the inverse is computed.
cacheSolve <- function(x, ...) {
     i <- x$getinverse()
     if(!is.null(i)) {
          message("getting cached data")
          return(i)
     }
     data <- x$get()
     i <- solve(data, ...)
     x$setinverse(i)
     i
}

##Worked example to check output is correct...
Mat <- makeCacheMatrix(matrix(c(1,0,5,2,1,6,3,4,0),3))
cacheSolve(Mat)

myMatrix <- matrix(c(1,0,5,2,1,6,3,4,0),3)
solve(myMatrix)
