///|
/// Calculates the intersection point of two lines in 3D space using parametric
/// equations. Uses the projection of the lines onto the xy-plane to find the
/// intersection parameter, then computes the actual intersection point in 3D
/// space.
///
/// Parameters:
///
/// * `first_line` : The first line segment in 3D space, defined by two
/// endpoints.
/// * `second_line` : The second line segment in 3D space, defined by two
/// endpoints.
///
/// Returns a point representing the intersection of the two lines. If the lines
/// are parallel or skew (not intersecting), returns a mathematically invalid
/// point.
///
/// Examples:
///
/// ```moonbit
/// test "intersection_line/intersecting" {
///   let l1 = new_line3d(new_point3d(0.0, 0.0, 0.0), new_point3d(2.0, 2.0, 0.0))
///   let l2 = new_line3d(new_point3d(0.0, 2.0, 0.0), new_point3d(2.0, 0.0, 0.0))
///   let result = intersection_line(l1, l2)
///   // Lines intersect at (1.0, 1.0, 0.0)
///   inspect!(result.x, content="1.0")
///   inspect!(result.y, content="1.0")
///   inspect!(result.z, content="0.0")
/// }
/// ```
fn intersection_line(u : Line3d, v : Line3d) -> Point3d {
  let ret : Point3d = u.a
  let t : Double = 
    (
      (u.a.x - v.a.x) * (v.a.y - v.b.y) - 
      (u.a.y - v.a.y) * (v.a.x - v.b.x)
    ) / 
    (
      (u.a.x - u.b.x) * (v.a.y - v.b.y) - 
      (u.a.y - u.b.y) * (v.a.x - v.b.x)
    )
  ret.x += t * (u.b.x - u.a.x)
  ret.y += t * (u.b.y - u.a.y)
  ret.z += t * (u.b.z - u.a.z)
  ret
}

///|
/// Calculates the intersection point between a line and a plane in 3D space.
/// Uses the parametric form of the line and the normal vector of the plane to
/// determine the exact point of intersection. The calculation involves finding a
/// parameter `t` that gives the point on the line that lies in the plane.
///
/// Parameters:
///
/// * `line` : A line segment in 3D space defined by two endpoints. The line
/// should not be parallel to the plane.
/// * `plane` : A plane in 3D space defined by three non-collinear points.
///
/// Returns a `Point3d` representing the intersection point of the line and
/// plane. If the line is parallel to the plane, the result is undefined.
///
/// Examples:
///
/// ```moonbit
/// test "intersection_line_plane/perpendicular" {
///   let line = new_line3d(new_point3d(1.0, 1.0, -1.0), new_point3d(1.0, 1.0, 1.0))
///   let plane = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0),
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   // Line perpendicular to xy-plane should intersect at z=0
///   let point = intersection_line_plane(line, plane)
///   inspect!(point.x, content="1.0")
///   inspect!(point.y, content="1.0")
///   inspect!(point.z, content="0.0")
/// }
/// ```
fn intersection_line_plane(l : Line3d, s : Plane3d) -> Point3d {
  let ret : Point3d = pvec_plane(s)
  let t : Double =
    (
      ret.x * (s.a.x - l.a.x) +
      ret.y * (s.a.y - l.a.y) +
      ret.z * (s.a.z - l.a.z)
    ) /
    (
      ret.x * (l.b.x - l.a.x) +
      ret.y * (l.b.y - l.a.y) +
      ret.z * (l.b.z - l.a.z)
    )
  ret.x = l.a.x + t * (l.b.x - l.a.x)
  ret.y = l.a.y + t * (l.b.y - l.a.y)
  ret.z = l.a.z + t * (l.b.z - l.a.z)
  ret
}

///|
/// Calculates the intersection line of two planes in 3D space. Uses a geometric
/// approach by finding intersection points of selected edges of one plane with
/// the other plane, then constructing a line that passes through these points.
///
/// Parameters:
///
/// * `first_plane` : The first plane in 3D space, defined by three non-collinear
/// points.
/// * `second_plane` : The second plane in 3D space, defined by three
/// non-collinear points.
///
/// Returns a `Line3d` representing the line of intersection between the two
/// planes. If the planes are parallel, the behavior is undefined.
///
/// Examples:
///
/// ```moonbit
/// test "intersection_plane_plane" {
///   let plane1 = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0), // point on xy-plane
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(0.0, 1.0, 0.0),
///   )
///   let plane2 = new_plane_3d(
///     new_point3d(0.0, 0.0, 0.0), // point on xz-plane
///     new_point3d(1.0, 0.0, 0.0),
///     new_point3d(0.0, 0.0, 1.0),
///   )
///   let intersection = intersection_plane_plane(plane1, plane2)
///   // Intersection should be the x-axis
///   inspect!(intersection.a.y, content="0.0")
///   inspect!(intersection.a.z, content="0.0")
///   inspect!(intersection.b.y, content="0.0")
///   inspect!(intersection.b.z, content="0.0")
/// }
/// ```
fn intersection_plane_plane(u : Plane3d, v : Plane3d) -> Line3d {
  let mut a : Point3d = new_point3d(0.0, 0.0, 0.0)
  let mut b : Point3d = new_point3d(0.0, 0.0, 0.0)
  
  if parallel_line_plane(new_line3d(v.a, v.b), u) {
    a = intersection_line_plane(new_line3d(v.b, v.c), u)
  } else {
    a = intersection_line_plane(new_line3d(v.a, v.b), u)
  }

  if parallel_line_plane(new_line3d(v.c, v.a), u) {
    b = intersection_line_plane(new_line3d(v.b, v.c), u)
  } else {
    b = intersection_line_plane(new_line3d(v.c, v.a), u)
  }

  new_line3d(a, b)
}