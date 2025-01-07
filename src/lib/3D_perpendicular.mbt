///|
/// Determines whether two line segments in 3D space are perpendicular. Line
/// segments are considered perpendicular if their direction vectors are
/// orthogonal, which occurs when their dot product equals zero (within a small
/// epsilon value to account for floating-point arithmetic).
///
/// Parameters:
///
/// * `first_line` : The first line segment, defined by two points in 3D space.
/// * `second_line` : The second line segment, defined by two points in 3D space.
///
/// Returns `true` if the line segments are perpendicular, `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "perpendicular_line/perpendicular" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(0.0, 1.0, 0.0))
///   // Lines along x-axis and y-axis should be perpendicular
///   inspect!(perpendicular_line(l1, l2), content="true")
/// }
/// 
/// test "perpendicular_line/not_perpendicular" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 1.0, 0.0))
///   // Lines at 45-degree angle should not be perpendicular
///   inspect!(perpendicular_line(l1, l2), content="false")
/// }
/// ```
fn perpendicular_line(u : Line3d, v : Line3d) -> Bool {
  iszero(dot3d(subt(u.a, u.b), subt(v.a, v.b)))
}

///|
/// Determines whether two planes in 3D space are perpendicular to each other.
/// Planes are considered perpendicular if their normal vectors are
/// perpendicular, which is checked by examining if the dot product of their
/// normal vectors is zero (within a small epsilon for floating-point precision).
///
/// Parameters:
///
/// * `first_plane` : The first plane, defined by three non-collinear points.
/// * `second_plane` : The second plane, defined by three non-collinear points.
///
/// Returns `true` if the planes are perpendicular to each other, `false`
/// otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "perpendicular_plane" {
///   let plane1 = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   let plane2 = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(1.0, 0.0, 1.0),
///   )
///   // First plane is the xy-plane (normal: 0,0,1)
///   // Second plane is the xz-plane (normal: 0,1,0)
///   // These planes should be perpendicular
///   inspect!(perpendicular_plane(plane1, plane2), content="true")
/// }
/// 
/// test "perpendicular_plane/not_perpendicular" {
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
///   // Parallel planes should not be perpendicular
///   inspect!(perpendicular_plane(plane1, plane2), content="false")
/// }
/// ```
fn perpendicular_plane(u : Plane3d, v : Plane3d) -> Bool {
  iszero(dot3d(pvec_plane(u), pvec_plane(v)))
}
