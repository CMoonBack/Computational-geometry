///|
/// Determines whether two line segments in 3D space are parallel. Line segments
/// are considered parallel if their direction vectors are parallel, accounting
/// for floating-point precision using an epsilon value.
///
/// Parameters:
///
/// * `first_line` : The first line segment, defined by two points in 3D space.
/// * `second_line` : The second line segment, defined by two points in 3D space.
///
/// Returns `true` if the line segments are parallel, `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "parallel_line/parallel" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 1.0, 1.0))
///   let l2 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(2.0, 2.0, 2.0))
///   // Lines with same direction vector should be parallel
///   inspect!(parallel_line(l1, l2), content="true")
/// }
/// 
/// test "parallel_line/not_parallel" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(0.0, 1.0, 0.0))
///   // Perpendicular lines should not be parallel
///   inspect!(parallel_line(l1, l2), content="false")
/// }
/// ```
fn parallel_line(u : Line3d, v : Line3d) -> Bool {
  vlen(mul3d(subt(u.a, u.b), subt(v.a, v.b))) < eps
}

///|
/// Determines whether two planes in 3D space are parallel. Two planes are
/// considered parallel if their normal vectors are parallel (or anti-parallel),
/// which is checked by examining if the cross product of their normal vectors
/// has a magnitude less than a small epsilon value.
///
/// Parameters:
///
/// * `first_plane` : The first plane, defined by three non-collinear points.
/// * `second_plane` : The second plane, defined by three non-collinear points.
///
/// Returns `true` if the planes are parallel, `false` otherwise.
///
/// Example:
///
/// ```moonbit
/// test "parallel_plane" {
///   let plane1 = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   let plane2 = new_plane_3d(
///     new_point3d(0.0, 0.0, 1.0),
///     new_point3d(1.0, 0.0, 1.0),
///     new_point3d(0.0, 1.0, 1.0),
///   )
///   // Two planes with the same normal vector (0,0,1) should be parallel
///   inspect!(parallel_plane(plane1, plane2), content="true")
/// }
/// ```
fn parallel_plane(u : Plane3d, v : Plane3d) -> Bool {
  vlen(mul3d(pvec_plane(u), pvec_plane(v))) < eps
}

///|
/// Determines whether a line is parallel to a plane in 3D space. A line is
/// considered parallel to a plane if the dot product of the line's direction
/// vector and the plane's normal vector is zero (within a small epsilon for
/// floating-point precision).
///
/// Parameters:
///
/// * `line` : A line segment in 3D space, defined by two endpoints.
/// * `plane` : A plane in 3D space, defined by three non-collinear points.
///
/// Returns `true` if the line is parallel to the plane, `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "parallel_line_plane/parallel" {
///   let line = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   // Line lying in the xy-plane should be parallel to the xy-plane
///   inspect!(parallel_line_plane(line, plane), content="true")
/// }
/// 
/// test "parallel_line_plane/not_parallel" {
///   let line = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(0.0, 0.0, 1.0))
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   // Line perpendicular to xy-plane should not be parallel
///   inspect!(parallel_line_plane(line, plane), content="false")
/// }
/// ```
fn parallel_line_plane(u : Line3d, v : Plane3d) -> Bool {
  iszero(dot3d(subt(u.a, u.b), pvec_plane(v)))
}
