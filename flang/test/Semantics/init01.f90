! RUN: %python %S/test_errors.py %s %flang_fc1
! Initializer error tests

subroutine objectpointers(j)
  integer, intent(in) :: j
  real, allocatable, target, save :: x1
  real, codimension[*], target, save :: x2
  real, save :: x3
  real, target :: x4
  real, target, save :: x5(10)
  real, pointer :: x6
  type t1
    real, allocatable :: c1
    real, allocatable, codimension[:] :: c2
    real :: c3
    real :: c4(10)
    real, pointer :: c5
  end type
  type(t1), target, save :: o1
  type(t1), save :: o2
!ERROR: Local variable 'o3' without the SAVE or ALLOCATABLE attribute may not have a coarray potential subobject component '%c2'
  type(t1), target :: o3
!ERROR: An initial data target may not be a reference to an ALLOCATABLE 'x1'
  real, pointer :: p1 => x1
!ERROR: An initial data target may not be a reference to a coarray 'x2'
  real, pointer :: p2 => x2
!ERROR: An initial data target may not be a reference to an object 'x3' that lacks the TARGET attribute
  real, pointer :: p3 => x3
!ERROR: An initial data target may not be a reference to an object 'x4' that lacks the SAVE attribute
  real, pointer :: p4 => x4
!ERROR: An initial data target must be a designator with constant subscripts
  real, pointer :: p5 => x5(j)
!ERROR: Pointer has rank 0 but target has rank 1
  real, pointer :: p6 => x5
!ERROR: An initial data target may not be a reference to a POINTER 'x6'
  real, pointer :: p7 => x6
!ERROR: An initial data target may not be a reference to an ALLOCATABLE 'c1'
  real, pointer :: p1o => o1%c1
!ERROR: An initial data target may not be a reference to a coarray 'c2'
  real, pointer :: p2o => o1%c2
!ERROR: An initial data target may not be a reference to an object 'o2' that lacks the TARGET attribute
  real, pointer :: p3o => o2%c3
!ERROR: An initial data target may not be a reference to an object 'o3' that lacks the SAVE attribute
  real, pointer :: p4o => o3%c3
!ERROR: An initial data target must be a designator with constant subscripts
  real, pointer :: p5o => o1%c4(j)
!ERROR: Pointer has rank 0 but target has rank 1
  real, pointer :: p6o => o1%c4
!ERROR: An initial data target may not be a reference to a POINTER 'c5'
  real, pointer :: p7o => o1%c5
  type t2
    !ERROR: An initial data target may not be a reference to an ALLOCATABLE 'x1'
    real, pointer :: p1 => x1
    !ERROR: An initial data target may not be a reference to a coarray 'x2'
    real, pointer :: p2 => x2
    !ERROR: An initial data target may not be a reference to an object 'x3' that lacks the TARGET attribute
    real, pointer :: p3 => x3
    !ERROR: An initial data target may not be a reference to an object 'x4' that lacks the SAVE attribute
    real, pointer :: p4 => x4
    !ERROR: An initial data target must be a designator with constant subscripts
    real, pointer :: p5 => x5(j)
    !ERROR: Pointer has rank 0 but target has rank 1
    real, pointer :: p6 => x5
    !ERROR: An initial data target may not be a reference to a POINTER 'x6'
    real, pointer :: p7 => x6
    !ERROR: An initial data target may not be a reference to an ALLOCATABLE 'c1'
    real, pointer :: p1o => o1%c1
    !ERROR: An initial data target may not be a reference to a coarray 'c2'
    real, pointer :: p2o => o1%c2
    !ERROR: An initial data target may not be a reference to an object 'o2' that lacks the TARGET attribute
    real, pointer :: p3o => o2%c3
    !ERROR: An initial data target may not be a reference to an object 'o3' that lacks the SAVE attribute
    real, pointer :: p4o => o3%c3
    !ERROR: An initial data target must be a designator with constant subscripts
    real, pointer :: p5o => o1%c4(j)
    !ERROR: Pointer has rank 0 but target has rank 1
    real, pointer :: p6o => o1%c4
    !ERROR: An initial data target may not be a reference to a POINTER 'c5'
    real, pointer :: p7o => o1%c5
  end type

!TODO: type incompatibility, non-deferred type parameter values, contiguity

end subroutine

subroutine dataobjects(j)
  integer, intent(in) :: j
  real, parameter :: x1(*) = [1., 2.]
!ERROR: Implied-shape parameter 'x2' has rank 2 but its initializer has rank 1
  real, parameter :: x2(*,*) = [1., 2.]
!ERROR: Named constant 'x3' array must have constant shape
  real, parameter :: x3(j) = [1., 2.]
!ERROR: Shape of initialized object 'x4' must be constant
  real :: x4(j) = [1., 2.]
!ERROR: Rank of initialized object is 2, but initialization expression has rank 1
  real :: x5(2,2) = [1., 2., 3., 4.]
  real :: x6(2,2) = 5.
!ERROR: Rank of initialized object is 0, but initialization expression has rank 1
  real :: x7 = [1.]
  real :: x8(2,2) = reshape([1., 2., 3., 4.], [2, 2])
!ERROR: Dimension 1 of initialized object has extent 3, but initialization expression has extent 2
  real :: x9(3) = [1., 2.]
!ERROR: Dimension 1 of initialized object has extent 2, but initialization expression has extent 3
  real :: x10(2,3) = reshape([real::(k,k=1,6)], [3, 2])
end subroutine

subroutine components(n)
  integer, intent(in) :: n
  real, target, save :: a1(3)
  real, target :: a2
  real, save :: a3
  real, target, save :: a4
  type :: t1
!ERROR: Dimension 1 of initialized object has extent 2, but initialization expression has extent 3
    real :: x1(2) = [1., 2., 3.]
  end type
  type :: t2(kind, len)
    integer, kind :: kind
    integer, len :: len
!ERROR: Dimension 1 of initialized object has extent 2, but initialization expression has extent 3
!ERROR: Dimension 1 of initialized object has extent 2, but initialization expression has extent 3
    real :: x1(2) = [1., 2., 3.]
!ERROR: Dimension 1 of initialized object has extent 2, but initialization expression has extent 3
    real :: x2(kind) = [1., 2., 3.]
!ERROR: Dimension 1 of initialized object has extent 2, but initialization expression has extent 3
!ERROR: Shape of initialized object 'x3' must be constant
    real :: x3(len) = [1., 2., 3.]
    real, pointer :: p1(:) => a1
!ERROR: An initial data target may not be a reference to an object 'a2' that lacks the SAVE attribute
!ERROR: An initial data target may not be a reference to an object 'a2' that lacks the SAVE attribute
    real, pointer :: p2 => a2
!ERROR: An initial data target may not be a reference to an object 'a3' that lacks the TARGET attribute
!ERROR: An initial data target may not be a reference to an object 'a3' that lacks the TARGET attribute
    real, pointer :: p3 => a3
!ERROR: Pointer has rank 0 but target has rank 1
!ERROR: Pointer has rank 0 but target has rank 1
    real, pointer :: p4 => a1
!ERROR: Pointer has rank 1 but target has rank 0
!ERROR: Pointer has rank 1 but target has rank 0
    real, pointer :: p5(:) => a4
  end type
  type(t2(3,2)) :: o1
  type(t2(2,n)) :: o2
  type :: t3
    real :: x
  end type
  type(t3), save, target :: o3
  real, pointer :: p10 => o3%x
  associate (a1 => o3, a2 => o3%x)
    block
      type(t3), pointer :: p11 => a1
      real, pointer :: p12 => a2
    end block
  end associate
end subroutine

subroutine notObjects
!ERROR: 'x1' is not an object that can be initialized
  real, external :: x1 = 1.
!ERROR: 'x2' is not a pointer but is initialized like one
  real, external :: x2 => sin
!ERROR: 'x3' is not a known intrinsic procedure
!ERROR: 'x3' is not an object that can be initialized
  real, intrinsic :: x3 = 1.
!ERROR: 'x4' is not a known intrinsic procedure
!ERROR: 'x4' is not a pointer but is initialized like one
  real, intrinsic :: x4 => cos
end subroutine

subroutine edgeCases
  integer :: j = 1, m = 2
  !ERROR: Data statement object must be a variable
  data k/3/
  data n/4/
  !ERROR: Named constant 'j' already has a value
  parameter(j = 5)
  !ERROR: Named constant 'k' already has a value
  parameter(k = 6)
  parameter(l = 7)
  !ERROR: 'm' was initialized earlier as a scalar
  dimension m(1)
  !ERROR: 'l' was initialized earlier as a scalar
  dimension l(1)
  !ERROR: 'n' was initialized earlier as a scalar
  dimension n(1)
end
