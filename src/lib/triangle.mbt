///|
/// Calculates the circumcenter of a triangle given its three vertices. The
/// circumcenter is the center of the circumscribed circle that passes through
/// all three vertices of the triangle. It is located at the intersection of the
/// perpendicular bisectors of any two sides of the triangle.
///
/// Parameters:
///
/// * `vertex1` : The first vertex of the triangle.
/// * `vertex2` : The second vertex of the triangle.
/// * `vertex3` : The third vertex of the triangle.
///
/// Returns a `Point` representing the circumcenter of the triangle.
///
/// Examples:
///
/// ```moonbit
/// test "circumcenter/equilateral" {
///   let a = new_point(0.0, 0.0)
///   let b = new_point(1.0, 0.0)
///   let c = new_point(0.5, 0.866025) // approximately √3/2
///   let center = circumcenter(a, b, c)
///   // For an equilateral triangle, the circumcenter is located at (0.5, 0.288675)
///   inspect!(center.x, content="0.5")
///   inspect!(center.y, content="0.288675")
/// }
/// 
/// test "circumcenter/right_triangle" {
///   let a = new_point(0.0, 0.0)
///   let b = new_point(1.0, 0.0)
///   let c = new_point(0.0, 1.0)
///   let center = circumcenter(a, b, c)
///   // For a right triangle, the circumcenter is at the midpoint of the hypotenuse
///   inspect!(center.x, content="0.5")
///   inspect!(center.y, content="0.5")
/// }
/// ```
fn circumcenter(a : Point, b : Point, c : Point) -> Point {
  let x1 : Double = (a.x + b.x) / 2.0
  let y1 : Double = (a.y + b.y) / 2.0
  let x2 : Double = x1 - a.y + b.y
  let y2 : Double = y1 + a.x - b.x
  let x3 : Double = (a.x + c.x) / 2.0
  let y3 : Double = (a.y + c.y) / 2.0
  let x4 : Double = x3 - a.y + c.y
  let y4 : Double = y3 + a.x - c.x
  intersection(
    new_point(x1, y1),
    new_point(x2, y2),
    new_point(x3, y3),
    new_point(x4, y4),
  )
}

///|
/// Calculates the incenter of a triangle given its three vertices. The incenter
/// is the point where the angle bisectors of a triangle intersect, and it is
/// equidistant from all sides of the triangle.
///
/// Parameters:
///
/// * `vertex1` : The first vertex of the triangle.
/// * `vertex2` : The second vertex of the triangle.
/// * `vertex3` : The third vertex of the triangle.
///
/// Returns the incenter point of the triangle.
///
/// Example:
///
/// ```moonbit
/// test "incenter" {
///   let a = new_point(0.0, 0.0)
///   let b = new_point(1.0, 0.0)
///   let c = new_point(0.0, 1.0)
///   let center = incenter(a, b, c)
///   // For a right triangle with vertices at (0,0), (1,0), and (0,1)
///   // the incenter is approximately at (0.2929, 0.2929)
///   inspect!(center.x < 0.293 && center.x > 0.292, content="true")
///   inspect!(center.y < 0.293 && center.y > 0.292, content="true")
/// }
/// 
/// test "incenter/equilateral" {
///   let a = new_point(0.0, 0.0)
///   let b = new_point(1.0, 0.0)
///   let c = new_point(0.5, 0.866) // approximately sin(60°)
///   let center = incenter(a, b, c)
///   // For an equilateral triangle, the incenter is at the centroid
///   inspect!(center.x < 0.501 && center.x > 0.499, content="true")
///   inspect!(center.y < 0.289 && center.y > 0.287, content="true")
/// }
/// ```
fn incenter(a : Point, b : Point, c : Point) -> Point {
  let u : Line = new_line(new_point(a.x, a.y), new_point(b.x, b.y))
  let v : Line = new_line(new_point(b.x, b.y), new_point(c.x, c.y))
  let m : Double = 0
  let n : Double = 0
  u.a = a
  let mut m : Double = @math.atan2(b.y - a.y, b.x - a.x)
  let mut n : Double = @math.atan2(c.y - a.y, c.x - a.x)
  u.b.x = u.a.x + @math.cos((m + n) / 2.0)
  u.b.y = u.a.y + @math.sin((m + n) / 2.0)
  v.a = b
  m = @math.atan2(a.y - b.y, a.x - b.x)
  n = @math.atan2(c.y - b.y, c.x - b.x)
  v.b.x = v.a.x + @math.cos((m + n) / 2.0)
  v.b.y = v.a.y + @math.sin((m + n) / 2.0)
  intersection(u.a, u.b, v.a, v.b)
}

///|
/// Calculates the orthocenter (perpendicular center) of a triangle. The
/// orthocenter is the point where the three altitudes of a triangle intersect.
/// An altitude is a line segment from a vertex perpendicular to the opposite
/// side (or its extension).
///
/// Parameters:
///
/// * `vertex1` : The first vertex of the triangle.
/// * `vertex2` : The second vertex of the triangle.
/// * `vertex3` : The third vertex of the triangle.
///
/// Returns a `Point` representing the orthocenter of the triangle.
///
/// Examples:
///
/// ```moonbit
/// test "perpencenter/right_triangle" {
///   // For a right triangle, the orthocenter is at the right angle vertex
///   let a = new_point(0.0, 0.0)
///   let b = new_point(3.0, 0.0)
///   let c = new_point(0.0, 4.0)
///   let center = perpencenter(a, b, c)
///   inspect!(center.x, content="0.0")
///   inspect!(center.y, content="0.0")
/// }
/// 
/// test "perpencenter/equilateral" {
///   // For an equilateral triangle, the orthocenter coincides with other centers
///   let a = new_point(0.0, 0.0)
///   let b = new_point(1.0, 1.732050808) // √3
///   let c = new_point(2.0, 0.0)
///   let center = perpencenter(a, b, c)
///   inspect!(center.x, content="1.0")
///   inspect!((center.y - 0.577350269).abs() < 0.000001, content="true") // 1/√3
/// }
/// ```
fn perpencenter(a : Point, b : Point, c : Point) -> Point {
  let u : Line = new_line(a, b)
  let v : Line = new_line(b, c)
  u.a = c
  u.b.x = u.a.x + b.y - a.y
  u.b.y = u.a.y - b.x + a.x
  v.a = b
  v.b.x = v.a.x - a.y + c.y
  v.b.y = v.a.y + a.x - c.x
  intersection(u.a, u.b, v.a, v.b)
}
