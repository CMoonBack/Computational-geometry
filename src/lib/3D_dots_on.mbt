///|
/// Determines if three points in 3D space are collinear (lie on the same
/// straight line). Uses vector operations to check if the cross product of
/// vectors formed by these points has a magnitude less than a small epsilon
/// value.
///
/// Parameters:
///
/// * `first_point` : The first point in 3D space.
/// * `second_point` : The second point in 3D space.
/// * `third_point` : The third point in 3D space.
///
/// Returns `true` if the three points are collinear, `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "Point3d::dots_inline/collinear" {
///   let p1 = new_point3d(0.0, 0.0, 0.0)
///   let p2 = new_point3d(1.0, 1.0, 1.0)
///   let p3 = new_point3d(2.0, 2.0, 2.0)
///   // Points lying on the line x = y = z
///   inspect!(Point3d::dots_inline(p1, p2, p3), content="true")
/// }
/// 
/// test "Point3d::dots_inline/non_collinear" {
///   let p1 = new_point3d(0.0, 0.0, 0.0)
///   let p2 = new_point3d(1.0, 0.0, 0.0)
///   let p3 = new_point3d(0.0, 1.0, 0.0)
///   // Points forming a right angle
///   inspect!(Point3d::dots_inline(p1, p2, p3), content="false")
/// }
/// ```
fn Point3d::dots_inline(p1 : Point3d, p2 : Point3d, p3 : Point3d) -> Bool {
  vlen(mul3d(subt(p1, p2), subt(p2, p3))) < eps
}

///|
/// Determines whether three points in 3D space lie on the same plane,
/// considering floating-point precision. Points are considered to be on the same
/// plane if they are collinear (lie on the same line) or if they form a plane
/// and one point lies on that plane.
///
/// Parameters:
///
/// * `first_point` : The first point in 3D space.
/// * `second_point` : The second point in 3D space.
/// * `third_point` : The third point in 3D space.
///
/// Returns `true` if all three points lie on the same plane, `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "dots_onplane/collinear" {
///   let p1 = new_point3d(0.0, 0.0, 0.0)
///   let p2 = new_point3d(1.0, 1.0, 1.0)
///   let p3 = new_point3d(2.0, 2.0, 2.0)
///   // Three points on the same line should be considered on the same plane
///   inspect!(dots_onplane(p1, p2, p3), content="true")
/// }
/// 
/// test "dots_onplane/planar" {
///   let p1 = new_point3d(0.0, 0.0, 0.0)
///   let p2 = new_point3d(1.0, 0.0, 0.0)
///   let p3 = new_point3d(0.0, 1.0, 0.0)
///   // Three points forming xy-plane
///   inspect!(dots_onplane(p1, p2, p3), content="true")
/// }
/// 
/// test "dots_onplane/non_planar" {
///   let p1 = new_point3d(0.0, 0.0, 0.0)
///   let p2 = new_point3d(1.0, 0.0, 0.0)
///   let p3 = new_point3d(0.0, 1.0, 1.0)
///   // Three points not on the same plane
///   inspect!(dots_onplane(p1, p2, p3), content="false")
/// }
/// ```
fn dots_onplane(p1 : Point3d, p2 : Point3d, p3 : Point3d, p4 : Point3d) -> Bool {
  iszero(dot3d(pvec_point(p1, p2, p3), subt(p1, p4)))
}

///|
/// Determines whether three points in 3D space are collinear and the second
/// point lies between the other two points. Uses vector cross product to check
/// collinearity and coordinate-wise comparisons to verify the middle point's
/// position.
///
/// Parameters:
///
/// * `self` : The first point in 3D space.
/// * `middle` : The point to check if it lies between the other two points.
/// * `end` : The third point in 3D space.
///
/// Returns `true` if `middle` lies between `self` and `end` on the same line,
/// `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "Point3d::dots_online_in/collinear" {
///   let p1 = new_point3d(0.0, 0.0, 0.0)
///   let p2 = new_point3d(1.0, 1.0, 1.0)
///   let p3 = new_point3d(2.0, 2.0, 2.0)
///   // p2 lies between p1 and p3 on the same line
///   inspect!(p1.dots_online_in(p2, p3), content="true")
/// }
/// 
/// test "Point3d::dots_online_in/not_between" {
///   let p1 = new_point3d(0.0, 0.0, 0.0)
///   let p2 = new_point3d(2.0, 2.0, 2.0)
///   let p3 = new_point3d(1.0, 1.0, 1.0)
///   // p2 does not lie between p1 and p3
///   inspect!(p1.dots_online_in(p2, p3), content="false")
/// }
/// ```
fn Point3d::dots_online_in(p1 : Point3d, p2 : Point3d, p3 : Point3d) -> Bool {
  iszero(vlen(mul3d(subt(p1, p2), subt(p2, p3)))) &&
  (p1.x - p2.x) * (p3.x - p2.x) < eps &&
  (p1.y - p2.y) * (p3.y - p2.y) < eps &&
  (p1.z - p2.z) * (p3.z - p2.z) < eps
}

///|
/// Determines if a point lies strictly on a line segment in 3D space, excluding
/// the endpoints. A point is considered to lie strictly on a line segment if it
/// is collinear with the segment's endpoints and lies between them, but is not
/// equal to either endpoint.
///
/// Parameters:
///
/// * `point` : The point to be tested.
/// * `segment_start` : The starting point of the line segment.
/// * `segment_end` : The ending point of the line segment.
///
/// Returns `true` if the point lies strictly on the line segment (excluding
/// endpoints), `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "Point3d::dots_online_ex/on_segment" {
///   let point = new_point3d(1.0, 1.0, 1.0)
///   let start = new_point3d(0.0, 0.0, 0.0)
///   let end = new_point3d(2.0, 2.0, 2.0)
///   // Point lies on the middle of the segment
///   inspect!(Point3d::dots_online_ex(point, start, end), content="true")
/// }
/// 
/// test "Point3d::dots_online_ex/at_endpoint" {
///   let point = new_point3d(0.0, 0.0, 0.0)
///   let start = new_point3d(0.0, 0.0, 0.0)
///   let end = new_point3d(2.0, 2.0, 2.0)
///   // Point is at segment endpoint, should return false
///   inspect!(Point3d::dots_online_ex(point, start, end), content="false")
/// }
/// ```
fn Point3d::dots_online_ex(p1 : Point3d, p2 : Point3d, p3 : Point3d) -> Bool {
  (Point3d::dots_online_in(p1, p2, p3) && not(iszero(p1.x - p2.x))) ||
  not(iszero(p1.y - p2.y)) ||
  (not(iszero(p1.z - p2.z)) && not(iszero(p1.x - p3.x))) ||
  not(iszero(p1.y - p3.y)) ||
  not(iszero(p1.z - p3.z))
}

///|
/// Determines whether a point lies inside a plane defined by three non-collinear
/// points. Uses the concept of area comparison: if the point lies in the plane,
/// the sum of the areas of three triangles formed by the point and any two
/// vertices of the plane should equal the area of the triangle formed by the
/// three vertices of the plane.
///
/// Parameters:
///
/// * `point` : The point to check, represented as a `Point3d` structure with x,
/// y, and z coordinates.
/// * `plane` : The plane to check against, defined by three non-collinear points
/// (a, b, c).
///
/// Returns `true` if the point lies in the plane, `false` otherwise.
///
/// Example:
///
/// ```moonbit
/// test "dot_inplane_in" {
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0), // origin
///     new_point3d(1.0, 0.0, 0.0), // point on x-axis
///     new_point3d(0.0, 1.0, 0.0), // point on y-axis
///   )
///   let point = new_point3d(0.5, 0.5, 0.0) // point in x-y plane
///   inspect!(dot_inplane_in(point, plane), content="true")
/// }
/// ```
fn dot_inplane_in(p : Point3d, s : Plane3d) -> Bool {
  iszero(
    vlen(mul3d(subt(s.a, s.b), subt(s.a, s.c))) -
    vlen(mul3d(subt(s.a, p), subt(s.b, p))) -
    vlen(mul3d(subt(s.a, p), subt(s.c, p))) -
    vlen(mul3d(subt(s.b, p), subt(s.c, p))),
  )
}
