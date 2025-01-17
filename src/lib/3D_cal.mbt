///|
/// Calculates the shortest distance between a point and a plane in 3D space.
/// Uses the formula |n·(p-a)|/|n|, where n is the normal vector of the plane, p
/// is the point, and a is a point on the plane.
///
/// Parameters:
///
/// * `point` : The point in 3D space from which to calculate the distance.
/// * `plane` : The plane in 3D space, defined by three non-collinear points.
///
/// Returns the perpendicular distance from the point to the plane.
///
/// Examples:
///
/// ```moonbit
/// test "p_to_plane/origin_to_xy" {
///   let point = new_point3d(0.0, 0.0, 1.0)
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0), // point on xy-plane
///     new_point3d(1.0, 0.0, 0.0), // point on xy-plane
///     new_point3d(0.0, 1.0, 0.0), // point on xy-plane
///   )
///   // Distance from point (0,0,1) to xy-plane should be 1.0
///   inspect!(p_to_plane(point, plane), content="1.0")
/// }
/// 
/// test "p_to_plane/point_on_plane" {
///   let point = new_point3d(1.0, 1.0, 0.0)
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(2.0, 0.0, 0.0),
///     new_point3d(0.0, 2.0, 0.0),
///   )
///   // Point lies on the plane, distance should be 0
///   inspect!(p_to_plane(point, plane), content="0.0")
/// }
/// ```
fn p_to_plane(p : Point3d, s : Plane3d) -> Double {
  Double::abs(dot3d(pvec_plane(s), subt(p, s.a))) / vlen(pvec_plane(s))
}

///|
/// Calculates the shortest distance between two lines in 3D space. Uses the
/// formula |((a₂-a₁)×(b₂-b₁))·(a₁-b₁)|/|(a₂-a₁)×(b₂-b₁)|, where a₁,a₂ and b₁,b₂
/// are the endpoints of the first and second line segments respectively.
///
/// Parameters:
///
/// * `first_line` : The first line segment in 3D space, defined by two
/// endpoints.
/// * `second_line` : The second line segment in 3D space, defined by two
/// endpoints.
///
/// Returns the shortest distance between the two line segments. If the lines are
/// parallel, returns the perpendicular distance between them.
///
/// Examples:
///
/// ```moonbit
/// test "line_to_line/skew" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(0.0, 1.0, 1.0), new_point3d(1.0, 1.0, 1.0))
///   // Distance between two skew lines (not in same plane)
///   inspect!(line_to_line(l1, l2), content="1.414214") // √2
/// }
/// 
/// test "line_to_line/parallel" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(0.0, 1.0, 0.0), new_point3d(1.0, 1.0, 0.0))
///   // Distance between two parallel lines
///   inspect!(line_to_line(l1, l2), content="1.0")
/// }
/// ```
fn line_to_line(u : Line3d, v : Line3d) -> Double {
  let n : Point3d = mul3d(subt(u.b, u.a), subt(v.b, v.a))
  Double::abs(dot3d(n, subt(u.a, v.a))) / vlen(n)
}

///|
/// Calculates the cosine of the angle between two line segments in 3D space.
/// Uses the dot product formula: cos(θ) = (a·b)/(|a|·|b|), where a and b are the
/// direction vectors of the line segments.
///
/// Parameters:
///
/// * `first_line` : The first line segment in 3D space, defined by two
/// endpoints.
/// * `second_line` : The second line segment in 3D space, defined by two
/// endpoints.
///
/// Returns the cosine of the angle between the two line segments. The result
/// will be in the range \[-1, 1], where:
///
/// * 1 indicates parallel lines pointing in the same direction
/// * -1 indicates parallel lines pointing in opposite directions
/// * 0 indicates perpendicular lines
///
/// Examples:
///
/// ```moonbit
/// test "angle_cos_line/parallel" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(2.0, 0.0, 0.0), new_point3d(3.0, 0.0, 0.0))
///   // Parallel lines in same direction should have cos(θ) = 1
///   inspect!(angle_cos_line(l1, l2), content="1.0")
/// }
/// 
/// test "angle_cos_line/perpendicular" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(0.0, 1.0, 0.0))
///   // Perpendicular lines should have cos(θ) = 0
///   inspect!(angle_cos_line(l1, l2), content="0.0")
/// }
/// ```
fn angle_cos_line(u : Line3d, v : Line3d) -> Double {
  dot3d(subt(u.b, u.a), subt(v.b, v.a)) /
  (vlen(subt(u.b, u.a)) * vlen(subt(v.b, v.a)))
}

///|
/// Calculates the cosine of the angle between a line and a plane in 3D space.
/// Uses the dot product between the plane's normal vector and the line's
/// direction vector, divided by their magnitudes.
///
/// Parameters:
///
/// * `line` : A line segment in 3D space, defined by two endpoints.
/// * `plane` : A plane in 3D space, defined by three non-collinear points.
///
/// Returns the cosine of the angle between the line and the plane. The value
/// ranges from -1 to 1, where:
///
/// * 0 indicates the line is parallel to the plane
/// * 1 or -1 indicates the line is perpendicular to the plane
/// * Other values indicate the degree of inclination
///
/// Example:
///
/// ```moonbit
/// test "angle_cos_plane/perpendicular" {
///   let line = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(0.0, 0.0, 1.0))
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0), // point on xy-plane
///     new_point3d(1.0, 0.0, 0.0), // point on xy-plane
///     new_point3d(0.0, 1.0, 0.0), // point on xy-plane
///   )
///   // Line perpendicular to xy-plane should have cosine of angle = 1
///   inspect!(angle_cos_plane(line, plane), content="1.0")
/// }
/// ```
fn angle_cos_plane(u : Line3d, v : Plane3d) -> Double {
  dot3d(pvec_plane(v), subt(u.b, u.a)) /
  (vlen(pvec_plane(v)) * vlen(subt(u.b, u.a)))
}

///|
/// Calculates the sine of the angle between a line segment and a plane in 3D
/// space. The calculation uses the dot product of the line's direction vector
/// and the plane's normal vector, divided by their magnitudes to obtain the sine
/// value.
///
/// Parameters:
///
/// * `line` : A line segment in 3D space, defined by two endpoints (`a` and
/// `b`).
/// * `plane` : A plane in 3D space, defined by three non-collinear points.
///
/// Returns the sine of the angle between the line and the plane. The value will
/// be in the range \[-1, 1], where:
///
/// * 0 indicates the line is parallel to the plane
/// * 1 indicates the line is perpendicular to the plane
/// * Values between 0 and 1 indicate acute angles
/// * Values between -1 and 0 indicate obtuse angles
///
/// Example:
///
/// ```moonbit
/// test "angle_sin_line_plane/perpendicular" {
///   let line = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(0.0, 0.0, 1.0))
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   // Line perpendicular to the xy-plane should have sine = 1
///   inspect!(angle_sin_line_plane(line, plane), content="1.0")
/// }
/// ```
fn angle_sin_line_plane(l : Line3d, s : Plane3d) -> Double {
  dot3d(subt(l.b, l.a), pvec_plane(s)) /
  (vlen(subt(l.b, l.a)) * vlen(pvec_plane(s)))
}
