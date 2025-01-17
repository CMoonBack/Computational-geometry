///|
struct Point3d {
  mut x : Double
  mut y : Double
  mut z : Double
}

///|
struct Line3d {
  a : Point3d
  b : Point3d
}

///|
struct Plane3d {
  a : Point3d
  b : Point3d
  c : Point3d
}

///|
/// Calculates the cross product of two three-dimensional vectors. The cross
/// product is a binary operation on two vectors in three-dimensional space that
/// results in a vector that is perpendicular to both of the vectors being
/// multiplied.
///
/// Parameters:
///
/// * `vector1` : The first three-dimensional vector.
/// * `vector2` : The second three-dimensional vector.
///
/// Returns a new vector that is perpendicular to both input vectors, with
/// magnitude equal to the area of the parallelogram defined by the two input
/// vectors.
///
/// Examples:
///
/// ```moonbit
/// test "mul3d/perpendicular" {
///   let v1 = new_point3d(1.0, 0.0, 0.0)
///   let v2 = new_point3d(0.0, 1.0, 0.0)
///   let result = mul3d(v1, v2)
///   // Cross product of i and j unit vectors should be k unit vector
///   inspect!(result.x, content="0.0")
///   inspect!(result.y, content="0.0")
///   inspect!(result.z, content="1.0")
/// }
/// ```
fn mul3d(u : Point3d, v : Point3d) -> Point3d {
  let ret : Point3d = new_point3d(0.0, 0.0, 0.0)
  ret.x = u.y * v.z - u.z * v.y
  ret.y = u.z * v.x - u.x * v.z
  ret.z = u.x * v.y - u.y * v.x
  ret
}

///|
/// Calculates the dot product (scalar product) of two 3D vectors. The dot
/// product is computed by multiplying corresponding components and summing the
/// results.
///
/// Parameters:
///
/// * `first_vector` : The first 3D vector, represented as a `Point3d` structure
/// with x, y, and z coordinates.
/// * `second_vector` : The second 3D vector, represented as a `Point3d`
/// structure with x, y, and z coordinates.
///
/// Returns the scalar value representing the dot product of the two vectors.
///
/// Examples:
///
/// ```moonbit
/// test "dot3d/perpendicular" {
///   let v1 = new_point3d(1.0, 0.0, 0.0)
///   let v2 = new_point3d(0.0, 1.0, 0.0)
///   // Perpendicular vectors have dot product of 0
///   inspect!(dot3d(v1, v2), content="0.0")
/// }
/// 
/// test "dot3d/parallel" {
///   let v1 = new_point3d(2.0, 3.0, 4.0)
///   let v2 = new_point3d(2.0, 3.0, 4.0)
///   // Dot product with itself gives sum of squares
///   inspect!(dot3d(v1, v2), content="29.0")
/// }
/// ```
fn dot3d(u : Point3d, v : Point3d) -> Double {
  u.x * v.x + u.y * v.y + u.z * v.z
}

///|
/// Calculates the vector difference between two 3D points (vectors). For each
/// coordinate (x, y, z), subtracts the corresponding coordinate of the second
/// point from the first point.
///
/// Parameters:
///
/// * `first` : The first 3D point, representing the minuend.
/// * `second` : The second 3D point, representing the subtrahend.
///
/// Returns a new `Point3d` representing the difference vector between the two
/// points.
///
/// Example:
///
/// ```moonbit
/// test "subt" {
///   let p1 = new_point3d(3.0, 4.0, 5.0)
///   let p2 = new_point3d(1.0, 1.0, 2.0)
///   let diff = subt(p1, p2)
///   inspect!(diff.x, content="2.0")
///   inspect!(diff.y, content="3.0")
///   inspect!(diff.z, content="3.0")
/// }
/// ```
fn subt(u : Point3d, v : Point3d) -> Point3d {
  let ret : Point3d = new_point3d(0.0, 0.0, 0.0)
  ret.x = u.x - v.x
  ret.y = u.y - v.y
  ret.z = u.z - v.z
  ret
}

///|
/// Calculates the normal vector of a plane using the cross product of two
/// vectors formed from three points on the plane. The vectors are formed by
/// subtracting point A from point B and point A from point C, where A, B, and C
/// are the three points defining the plane.
///
/// Parameters:
///
/// * `plane` : A plane defined by three points (A, B, C) in 3D space. The points
/// should not be collinear to ensure a valid normal vector.
///
/// Returns a `Point3d` representing the normal vector of the plane, calculated
/// as the cross product of vectors (B-A) × (C-A).
///
/// Example:
///
/// ```moonbit
/// test "pvec_plane" {
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0), // point A at origin
///     new_point3d(1.0, 0.0, 0.0), // point B on x-axis
///     new_point3d(0.0, 1.0, 0.0), // point C on y-axis
///   )
///   let normal = pvec_plane(plane)
///   // Normal vector should be (0, 0, 1) for a plane in x-y plane
///   inspect!(normal.x, content="0.0")
///   inspect!(normal.y, content="0.0")
///   inspect!(normal.z, content="1.0")
/// }
/// ```
fn pvec_plane(s : Plane3d) -> Point3d {
  mul3d(subt(s.b, s.a), subt(s.c, s.a))
}

///|
/// Calculates the cross product of two vectors formed by three points in 3D
/// space. The first vector is formed from the second point to the first point,
/// and the second vector is formed from the second point to the third point.
///
/// Parameters:
///
/// * `point1` : The first point in 3D space.
/// * `point2` : The second point in 3D space, serving as the common point for
/// both vectors.
/// * `point3` : The third point in 3D space.
///
/// Returns a `Point3d` representing the cross product vector of the two vectors
/// formed by these points.
///
/// Example:
///
/// ```moonbit
/// test "pvec_point" {
///   let p1 = new_point3d(1.0, 0.0, 0.0)
///   let p2 = new_point3d(0.0, 0.0, 0.0)
///   let p3 = new_point3d(0.0, 1.0, 0.0)
///   let result = pvec_point(p1, p2, p3)
///   // Cross product of vectors (1,0,0) and (0,1,0) should be (0,0,1)
///   inspect!(result.x, content="0.0")
///   inspect!(result.y, content="0.0")
///   inspect!(result.z, content="1.0")
/// }
/// ```
fn pvec_point(s1 : Point3d, s2 : Point3d, s3 : Point3d) -> Point3d {
  mul3d(subt(s1, s2), subt(s2, s3))
}

///|
/// Calculates the Euclidean distance between two points in three-dimensional
/// space using the formula √((x₁-x₂)² + (y₁-y₂)² + (z₁-z₂)²).
///
/// Parameters:
///
/// * `point1` : The first point in 3D space, represented as a `Point3d`
/// structure with x, y, and z coordinates.
/// * `point2` : The second point in 3D space, represented as a `Point3d`
/// structure with x, y, and z coordinates.
///
/// Returns the Euclidean distance between the two points.
///
/// Examples:
///
/// ```moonbit
/// test "distance3d/origin" {
///   let p1 = new_point3d(0.0, 0.0, 0.0)
///   let p2 = new_point3d(1.0, 1.0, 1.0)
///   // Distance from origin to point (1,1,1)
///   inspect!(distance3d(p1, p2), content="1.732051") // approximately √3
/// }
/// 
/// test "distance3d/arbitrary" {
///   let p1 = new_point3d(2.0, -1.0, 3.0)
///   let p2 = new_point3d(-1.0, 2.0, 1.0)
///   // Distance between two arbitrary points
///   inspect!(distance3d(p1, p2), content="5.0") // 5.0 units apart
/// }
/// ```
fn distance3d(p1 : Point3d, p2 : Point3d) -> Double {
  Double::sqrt(
    (p1.x - p2.x) * (p1.x - p2.x) +
    (p1.y - p2.y) * (p1.y - p2.y) +
    (p1.z - p2.z) * (p1.z - p2.z),
  )
}

///|
/// Calculates the magnitude (length) of a 3D vector represented by a point in 3D
/// space. Uses the Euclidean distance formula: √(x² + y² + z²).
///
/// Parameters:
///
/// * `vector` : A point in 3D space representing a vector from the origin to
/// that point.
///
/// Returns the magnitude (length) of the vector.
///
/// Examples:
///
/// ```moonbit
/// test "vlen/unit_vector" {
///   let unit_x = new_point3d(1.0, 0.0, 0.0)
///   // Unit vector should have length 1
///   inspect!(vlen(unit_x), content="1.0")
/// }
/// 
/// test "vlen/arbitrary_vector" {
///   let v = new_point3d(3.0, 4.0, 0.0)
///   // Vector (3,4,0) should have length 5
///   inspect!(vlen(v), content="5.0")
/// }
/// ```
fn vlen(p : Point3d) -> Double {
  Double::sqrt(p.x * p.x + p.y * p.y + p.z * p.z)
}

///|
/// Creates a new point in a 3D coordinate system with the specified x, y, and z
/// coordinates.
///
/// Parameters:
///
/// * `x` : The x-coordinate of the point.
/// * `y` : The y-coordinate of the point.
/// * `z` : The z-coordinate of the point.
///
/// Returns a `Point3d` struct containing the specified coordinates.
///
/// Examples:
///
/// ```moonbit
/// test "new_point3d" {
///   let p = new_point3d(1.0, 2.0, 3.0)
///   inspect!(p.x, content="1.0")
///   inspect!(p.y, content="2.0")
///   inspect!(p.z, content="3.0")
/// }
/// 
/// test "new_point3d/negative_coordinates" {
///   let p = new_point3d(-3.0, -4.0, -5.0)
///   inspect!(p.x, content="-3.0")
///   inspect!(p.y, content="-4.0")
///   inspect!(p.z, content="-5.0")
/// }
/// ```
pub fn new_point3d(x_ : Double, y_ : Double, z_ : Double) -> Point3d {
  let ans = { x: x_, y: y_, z: z_ }
  ans
}

///|
/// Creates a new 3D line segment defined by two endpoints in a three-dimensional
/// coordinate system.
///
/// Parameters:
///
/// * `start_point` : The starting point of the line segment, represented as a
/// `Point3d` structure with x, y, and z coordinates.
/// * `end_point` : The ending point of the line segment, represented as a
/// `Point3d` structure with x, y, and z coordinates.
///
/// Returns a `Line3d` structure representing the line segment between the two
/// specified points.
///
/// Example:
///
/// ```moonbit
/// test "new_line3d" {
///   let start = new_point3d(1.0, 2.0, 3.0)
///   let end = new_point3d(4.0, 5.0, 6.0)
///   let line = new_line3d(start, end)
///   inspect!(line.a.x, content="1.0")
///   inspect!(line.b.z, content="6.0")
/// }
/// ```
pub fn new_line3d(a_ : Point3d, b_ : Point3d) -> Line3d {
  let ans : Line3d = { a: a_, b: b_ }
  ans
}

///|
/// Creates a new 3D plane defined by three non-collinear points. The plane is
/// represented in point-normal form, where the normal vector is determined by
/// the cross product of two vectors formed by these points.
///
/// Parameters:
///
/// * `point1` : The first point defining the plane.
/// * `point2` : The second point defining the plane.
/// * `point3` : The third point defining the plane.
///
/// Returns a `plane3d` structure representing the plane passing through the
/// three given points.
///
/// Example:
///
/// ```moonbit
/// test "new_plane_3d" {
///   let p1 = new_point3d(0.0, 0.0, 0.0)
///   let p2 = new_point3d(1.0, 0.0, 0.0)
///   let p3 = new_point3d(0.0, 1.0, 0.0)
///   let plane = new_plane_3d(p1, p2, p3)
///   // Creates a plane with normal vector (0, 0, 1)
///   inspect!(plane.a.x, content="0.0")
///   inspect!(plane.b.x, content="1.0")
///   inspect!(plane.c.y, content="1.0")
/// }
/// ```
pub fn new_plane_3d(a_ : Point3d, b_ : Point3d, c_ : Point3d) -> Plane3d {
  let ans : Plane3d = { a: a_, b: b_, c: c_ }
  ans
}
