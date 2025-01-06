///|
/// Determines whether two points lie on the same side of a line segment in 3D
/// space. Points are considered to be on the same side if the dot products of
/// vectors formed from one endpoint of the line segment to each point have the
/// same sign.
///
/// Parameters:
///
/// * `first_point` : The first point to check.
/// * `second_point` : The second point to check.
/// * `line_segment` : The line segment that serves as the divider, defined by
/// two endpoints.
///
/// Returns `true` if both points lie on the same side of the line segment,
/// `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "Point3d::same_side_seg/same_side" {
///   let p1 = new_point3d(0.0, 1.0, 0.0)
///   let p2 = new_point3d(0.0, 2.0, 0.0)
///   let line = new_line3d(new_point3d(-1.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   // Points are on the same side (above) of the line in the xy-plane
///   inspect!(Point3d::same_side_seg(p1, p2, line), content="true")
/// }
/// 
/// test "Point3d::same_side_seg/opposite_sides" {
///   let p1 = new_point3d(0.0, 1.0, 0.0)
///   let p2 = new_point3d(0.0, -1.0, 0.0)
///   let line = new_line3d(new_point3d(-1.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   // Points are on opposite sides of the line in the xy-plane
///   inspect!(Point3d::same_side_seg(p1, p2, line), content="false")
/// }
/// ```
fn Point3d::same_side_seg(p1 : Point3d, p2 : Point3d, l : Line3d) -> Bool {
  dot3d(subt(p1, l.a), subt(l.a, l.b)) * dot3d(subt(p2, l.a), subt(l.a, l.b)) > eps
}

///|
/// Determines whether two points lie on opposite sides of a line segment in 3D
/// space. Points are considered to be on opposite sides if the dot products of
/// vectors formed from the line segment's start point to each point have
/// different signs.
///
/// Parameters:
///
/// * `point1` : The first point to check.
/// * `point2` : The second point to check.
/// * `line` : The line segment that serves as the divider.
///
/// Returns `true` if the points lie on opposite sides of the line segment,
/// `false` otherwise.
///
/// Example:
///
/// ```moonbit
/// test "Point3d::opposite_side_seg" {
///   let p1 = new_point3d(0.0, 1.0, 0.0)
///   let p2 = new_point3d(0.0, -1.0, 0.0)
///   let line = new_line3d(new_point3d(-1.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   // Points are on opposite sides of the x-axis
///   inspect!(Point3d::opposite_side_seg(p1, p2, line), content="true")
/// }
/// 
/// test "Point3d::opposite_side_seg/same_side" {
///   let p1 = new_point3d(0.0, 1.0, 0.0)
///   let p2 = new_point3d(0.0, 2.0, 0.0)
///   let line = new_line3d(new_point3d(-1.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   // Points are on the same side of the x-axis
///   inspect!(Point3d::opposite_side_seg(p1, p2, line), content="false")
/// }
/// ```
fn Point3d::opposite_side_seg(p1 : Point3d, p2 : Point3d, l : Line3d) -> Bool {
  dot3d(subt(p1, l.a), subt(l.a, l.b)) * dot3d(subt(p2, l.a), subt(l.a, l.b)) < -eps
}

///|
/// Determines whether two points lie on the same side of a plane in 3D space.
/// Points are considered to be on the same side if the dot products of the
/// plane's normal vector with vectors from a point on the plane to each of the
/// test points have the same sign.
///
/// Parameters:
///
/// * `first_point` : The first point to check, represented as a `Point3d` with
/// x, y, and z coordinates.
/// * `second_point` : The second point to check, represented as a `Point3d` with
/// x, y, and z coordinates.
/// * `plane` : The plane to check against, defined by three non-collinear
/// points.
///
/// Returns `true` if both points lie on the same side of the plane, `false`
/// otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "Point3d::same_side_plane/same_side" {
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0), // point on plane
///     new_point3d(1.0, 0.0, 0.0), // point on plane
///     new_point3d(0.0, 1.0, 0.0), // point on plane
///   )
///   let p1 = new_point3d(0.0, 0.0, 1.0) // point above plane
///   let p2 = new_point3d(1.0, 1.0, 1.0) // another point above plane
///   inspect!(Point3d::same_side_plane(p1, p2, plane), content="true")
/// }
/// 
/// test "Point3d::same_side_plane/opposite_sides" {
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0), // point on plane
///     new_point3d(1.0, 0.0, 0.0), // point on plane
///     new_point3d(0.0, 1.0, 0.0), // point on plane
///   )
///   let p1 = new_point3d(0.0, 0.0, 1.0) // point above plane
///   let p2 = new_point3d(0.0, 0.0, -1.0) // point below plane
///   inspect!(Point3d::same_side_plane(p1, p2, plane), content="false")
/// }
/// ```
fn Point3d::same_side_plane(p1 : Point3d, p2 : Point3d, s : Plane3d) -> Bool {
  dot3d(pvec_plane(s), subt(p1, s.a)) * dot3d(pvec_plane(s), subt(p2, s.a)) > eps
}

///|
/// Determines whether two points lie on opposite sides of a plane. Points are
/// considered to be on opposite sides if the dot products of the plane's normal
/// vector with vectors from a point on the plane to each point have different
/// signs (i.e., one is positive and one is negative).
///
/// Parameters:
///
/// * `first_point` : The first point in 3D space to check.
/// * `second_point` : The second point in 3D space to check.
/// * `plane` : The plane that potentially separates the two points, defined by
/// three non-collinear points.
///
/// Returns `true` if the points lie on opposite sides of the plane, `false`
/// otherwise.
///
/// Example:
///
/// ```moonbit
/// test "Point3d::opposite_side_plane" {
///   let p1 = new_point3d(0.0, 0.0, 1.0)
///   let p2 = new_point3d(0.0, 0.0, -1.0)
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   // Points are on opposite sides of the xy-plane
///   inspect!(Point3d::opposite_side_plane(p1, p2, plane), content="true")
/// }
/// ```
fn Point3d::opposite_side_plane(p1 : Point3d, p2 : Point3d, s : Plane3d) -> Bool {
  dot3d(pvec_plane(s), subt(p1, s.a)) * dot3d(pvec_plane(s), subt(p2, s.a)) < -eps
}