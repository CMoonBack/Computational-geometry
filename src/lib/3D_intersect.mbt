///|
/// Determines whether two line segments in 3D space intersect or touch,
/// including endpoints. Two line segments are considered intersecting if they
/// share at least one point, either at their endpoints or along their lengths.
///
/// Parameters:
///
/// * `first_segment` : The first line segment in 3D space.
/// * `second_segment` : The second line segment in 3D space.
///
/// Returns `true` if the line segments intersect (including touching at
/// endpoints), `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "intersect_seg_in/crossing" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(2.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(1.0, -1.0, 0.0), new_point3d(1.0, 1.0, 0.0))
///   // Two segments crossing at (1.0, 0.0, 0.0)
///   inspect!(intersect_seg_in(l1, l2), content="true")
/// }
/// 
/// test "intersect_seg_in/touching" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(1.0, 0.0, 0.0), new_point3d(1.0, 1.0, 0.0))
///   // Two segments touching at endpoint (1.0, 0.0, 0.0)
///   inspect!(intersect_seg_in(l1, l2), content="true")
/// }
/// 
/// test "intersect_seg_in/skew" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(1.0, 0.0, 0.0))
///   let l2 = new_line3d(new_point3d(0.0, 1.0, 1.0), new_point3d(1.0, 1.0, 1.0))
///   // Two skew lines (not in the same plane)
///   inspect!(intersect_seg_in(l1, l2), content="false")
/// }
/// ```
fn intersect_seg_in(u : Line3d, v : Line3d) -> Bool {
  if not(dots_onplane(u.a, u.b, v.a, v.b)) {
    return true
  }
  if not(Point3d::dots_inline(u.a, u.b, v.a) || Point3d::dots_inline(u.a, u.b, v.b)) {
    return not(same_side_seg(u.a, u.b, v) && not(same_side_seg(v.a, v.b, u)))
  }
  return Point3d::dots_online_in(u.a, v.a, v.b) || 
  Point3d::dots_online_in(u.b, v.a, v.b) || 
  Point3d::dots_online_in(v.a, u.a, u.b) || 
  Point3d::dots_online_in(v.b, u.a, u.b)
}

///|
/// Determines whether two line segments in 3D space intersect exclusively,
/// meaning they intersect at a point that is strictly interior to both segments
/// (not at their endpoints). Uses a combination of plane orientation and segment
/// side tests to determine intersection.
///
/// Parameters:
///
/// * `first_segment` : The first line segment, defined by two endpoints in 3D
/// space.
/// * `second_segment` : The second line segment, defined by two endpoints in 3D
/// space.
///
/// Returns `true` if the line segments intersect exclusively (excluding
/// endpoints), `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "intersect_seg_ex/crossing" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(2.0, 2.0, 0.0))
///   let l2 = new_line3d(new_point3d(0.0, 2.0, 0.0), new_point3d(2.0, 0.0, 0.0))
///   // Lines crossing at their midpoints (1,1,0)
///   inspect!(intersect_seg_ex(l1, l2), content="true")
/// }
/// 
/// test "intersect_seg_ex/endpoint" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(2.0, 2.0, 0.0))
///   let l2 = new_line3d(new_point3d(2.0, 2.0, 0.0), new_point3d(4.0, 2.0, 0.0))
///   // Lines touching at endpoint (2,2,0)
///   inspect!(intersect_seg_ex(l1, l2), content="false")
/// }
/// ```
fn intersect_seg_ex(u : Line3d, v : Line3d) -> Bool {
  dots_onplane(u.a, u.b, v.a, v.b) &&
  Point3d::opposite_side_seg(u.a, u.b, v) &&
  Point3d::opposite_side_seg(v.a, v.b, u)
}

///|
/// Determines whether a line segment intersects with a triangle in 3D space,
/// including cases where the line segment touches or lies within the triangle.
/// Uses a combination of plane orientation tests to determine intersection.
///
/// Parameters:
///
/// * `line` : A line segment in 3D space, defined by two endpoints.
/// * `triangle` : A triangle in 3D space, defined by three vertices.
///
/// Returns `true` if the line segment intersects with the triangle (including
/// touching or lying within), `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "intersect_triangle_in/through" {
///   let line = new_line3d(new_point3d(0.0, 0.0, 1.0), new_point3d(0.0, 0.0, -1.0))
///   let triangle = new_plane_3d(
///     new_point3d(-1.0, -1.0, 0.0),
///     new_point3d(1.0, -1.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   // Line passing through the center of the triangle
///   inspect!(intersect_triangle_in(line, triangle), content="true")
/// }
/// 
/// test "intersect_triangle_in/outside" {
///   let line = new_line3d(new_point3d(2.0, 2.0, 1.0), new_point3d(2.0, 2.0, -1.0))
///   let triangle = new_plane_3d(
///     new_point3d(-1.0, -1.0, 0.0),
///     new_point3d(1.0, -1.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   // Line completely outside the triangle
///   inspect!(intersect_triangle_in(line, triangle), content="false")
/// }
/// ```
fn intersect_triangle_in(l : Line3d, s : Plane3d) -> Bool {
  not(same_side_plane(l.a, l.b, s)) && 
  not(same_side_plane2(s.a, s.b, l.a, l.b, s.c)) && 
  not(same_side_plane2(s.b, s.c, l.a, l.b, s.a)) &&
  not(same_side_plane2(s.c, s.a, l.a, l.b, s.b))
}

///|
/// Determines whether a line segment strictly intersects with a triangle in 3D
/// space. A strict intersection means the line segment intersects the triangle
/// at a single point that is not on the triangle's edges or vertices.
///
/// Parameters:
///
/// * `line` : A line segment in 3D space, defined by two endpoints.
/// * `triangle` : A triangle in 3D space, defined by three vertices as a
/// `Plane3d` structure.
///
/// Returns `true` if the line segment strictly intersects with the triangle
/// (excluding intersections on edges and vertices), `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "intersect_triangle_ex/through_center" {
///   let triangle = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0), // First vertex at origin
///     new_point3d(2.0, 0.0, 0.0), // Second vertex on x-axis
///     new_point3d(1.0, 2.0, 0.0), // Third vertex above
///   )
///   let line = new_line3d(
///     new_point3d(1.0, 1.0, -1.0), // Start point below triangle
///     new_point3d(1.0, 1.0, 1.0), // End point above triangle
///   )
///   // Line passes through center of triangle
///   inspect!(intersect_triangle_ex(line, triangle), content="true")
/// }
/// 
/// test "intersect_triangle_ex/on_edge" {
///   let triangle = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(2.0, 0.0, 0.0),
///     new_point3d(1.0, 2.0, 0.0),
///   )
///   let line = new_line3d(
///     new_point3d(1.0, 0.0, -1.0), // Start point below edge
///     new_point3d(1.0, 0.0, 1.0), // End point above edge
///   )
///   // Line intersects triangle on an edge, should return false
///   inspect!(intersect_triangle_ex(line, triangle), content="false")
/// }
/// ```
fn intersect_triangle_ex(l : Line3d, s : Plane3d) -> Bool {
  Point3d::opposite_side_plane(l.a, l.b, s) &&
  Point3d::opposite_side_plane2(s.a, s.b, l.a, l.b, s.c) &&
  Point3d::opposite_side_plane2(s.b, s.c, l.a, l.b, s.a) &&
  Point3d::opposite_side_plane2(s.c, s.a, l.a, l.b, s.b)
}