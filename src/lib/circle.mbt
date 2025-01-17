///|
struct Circle {
  c : Point
  r : Double
}

///|
/// Determines if a line intersects with a circle. A line is considered to
/// intersect with a circle if the perpendicular distance from the circle's
/// center to the line is less than or equal to the circle's radius (accounting
/// for floating-point precision).
///
/// Parameters:
///
/// * `line` : A line segment defined by two points.
/// * `circle` : A circle defined by its center point and radius.
///
/// Returns `true` if the line intersects with the circle, `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "intersect_line_circle/intersecting" {
///   let line = new_line(new_point(0.0, 0.0), new_point(2.0, 0.0))
///   let circle = Circle{ c: new_point(1.0, 1.0), r: 1.5 }
///   // Line should intersect with circle
///   inspect!(intersect_line_circle(line, circle), content="true")
/// }
/// 
/// test "intersect_line_circle/non_intersecting" {
///   let line = new_line(new_point(0.0, 0.0), new_point(2.0, 0.0))
///   let circle = Circle{ c: new_point(1.0, 2.0), r: 0.5 }
///   // Line should not intersect with circle
///   inspect!(intersect_line_circle(line, circle), content="false")
/// }
/// ```
fn intersect_line_circle(l : Line, c : Circle) -> Bool {
  dis_p_to_line(c.c, l.a, l.b) < c.r + eps
}

///|
/// Determines whether a line segment intersects with a circle. A line segment is
/// considered to intersect with a circle if any point of the segment lies inside
/// or on the circle, or if the segment crosses the circle's boundary.
///
/// Parameters:
///
/// * `segment_start` : The starting point of the line segment.
/// * `segment_end` : The ending point of the line segment.
/// * `circle` : The circle to check for intersection, defined by its center
/// point and radius.
///
/// Returns `true` if the line segment intersects with the circle, `false`
/// otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "intersect_seg_circle/tangent" {
///   let circle = Circle::{ c: new_point(0.0, 0.0), r: 1.0 }
///   let start = new_point(1.0, 0.0)
///   let end = new_point(1.0, 2.0)
///   // Line segment is tangent to the circle
///   inspect!(intersect_seg_circle(start, end, circle), content="true")
/// }
/// 
/// test "intersect_seg_circle/outside" {
///   let circle = Circle::{ c: new_point(0.0, 0.0), r: 1.0 }
///   let start = new_point(2.0, 0.0)
///   let end = new_point(2.0, 2.0)
///   // Line segment is completely outside the circle
///   inspect!(intersect_seg_circle(start, end, circle), content="false")
/// }
/// 
/// test "intersect_seg_circle/through" {
///   let circle = Circle::{ c: new_point(0.0, 0.0), r: 1.0 }
///   let start = new_point(-2.0, 0.0)
///   let end = new_point(2.0, 0.0)
///   // Line segment passes through the circle
///   inspect!(intersect_seg_circle(start, end, circle), content="true")
/// }
/// ```
fn intersect_seg_circle(l1 : Point, l2 : Point, c : Circle) -> Bool {
  let t1 : Double = distance(c.c, l1) - c.r
  let t2 : Double = distance(c.c, l2) - c.r
  let t : Point = c.c
  if t1 < eps || t2 < eps {
    return t1 > -eps || t2 > -eps
  }
  t.x = t.x + l1.y - l2.y
  t.y = t.y + l2.x - l1.x
  mul(l1, c.c, t) * mul(l2, c.c, t) < eps &&
  dis_p_to_line(c.c, l1, l2) < c.r + eps
}

///|
/// Determines whether two circles intersect with each other. Two circles
/// intersect if their distance is less than the sum of their radii but greater
/// than the absolute difference of their radii (within a small epsilon value to
/// account for floating-point precision).
///
/// Parameters:
///
/// * `circle1` : The first circle, defined by a center point and radius.
/// * `circle2` : The second circle, defined by a center point and radius.
///
/// Returns `true` if the circles intersect, `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "intersect_circle_circle/intersecting" {
///   let c1 = Circle::{ c: new_point(0.0, 0.0), r: 2.0 }
///   let c2 = Circle::{ c: new_point(3.0, 0.0), r: 2.0 }
///   // Circles touch at one point
///   inspect!(intersect_circle_circle(c1, c2), content="true")
/// }
/// 
/// test "intersect_circle_circle/non_intersecting" {
///   let c1 = Circle::{ c: new_point(0.0, 0.0), r: 1.0 }
///   let c2 = Circle::{ c: new_point(3.0, 0.0), r: 1.0 }
///   // Circles are too far apart to intersect
///   inspect!(intersect_circle_circle(c1, c2), content="false")
/// }
/// 
/// test "intersect_circle_circle/contained" {
///   let c1 = Circle::{ c: new_point(0.0, 0.0), r: 3.0 }
///   let c2 = Circle::{ c: new_point(1.0, 0.0), r: 1.0 }
///   // One circle is contained within the other
///   inspect!(intersect_circle_circle(c1, c2), content="false")
/// }
/// ```
fn intersect_circle_circle(c1 : Circle, c2 : Circle) -> Bool {
  distance(c1.c, c2.c) < c1.r + c2.r + eps &&
  distance(c1.c, c2.c) > Double::abs(c1.r - c2.r) - eps
}

///|
/// Finds the closest point on a circle's circumference to a given point. If the
/// given point is at the circle's center, returns the point itself. Otherwise,
/// calculates two possible points on the circumference and returns the one
/// closer to the input point.
///
/// Parameters:
///
/// * `circle` : The circle, defined by its center point and radius.
/// * `point` : The point for which to find the closest point on the circle.
///
/// Returns a point on the circle's circumference that is closest to the input
/// point.
///
/// Examples:
///
/// ```moonbit
/// test "dot_to_circle/center" {
///   let circle = Circle::{ c: new_point(0.0, 0.0), r: 1.0 }
///   let point = new_point(0.0, 0.0)
///   // When point is at center, returns the point itself
///   let result = dot_to_circle(circle, point)
///   inspect!(result.x, content="0.0")
///   inspect!(result.y, content="0.0")
/// }
/// 
/// test "dot_to_circle/outside" {
///   let circle = Circle::{ c: new_point(0.0, 0.0), r: 1.0 }
///   let point = new_point(2.0, 0.0)
///   // Point outside circle projects to nearest point on circumference
///   let result = dot_to_circle(circle, point)
///   inspect!(result.x, content="1.0")
///   inspect!(result.y, content="0.0")
/// }
/// ```
fn dot_to_circle(c : Circle, p : Point) -> Point {
  let u : Point = p
  let v : Point = p
  //p为圆心时，返回圆心本身
  if distance(p, c.c) < eps {
    return c.c
  }
  u.x = c.c.x + c.r * Double::abs(c.c.x - p.x) / distance(p, c.c)
  let t = c.c.y + c.r * Double::abs(c.c.y - p.y) / distance(p, c.c)
  if t < 0 {
    u.y = -1
  } else {
    u.y = 1
  }
  v.x = c.c.x - c.r * Double::abs(c.c.x - p.x) / distance(p, c.c)
  let tt = c.c.y - c.r * Double::abs(c.c.y - p.y) / distance(p, c.c)
  if tt < 0 {
    v.y = -1
  } else {
    v.y = 1
  }
  if distance(p, u) < distance(p, v) {
    return u
  } else {
    return v
  }
}

///|
/// Calculates the intersection points between a line and a circle. Uses the
/// perpendicular distance
/// from the circle's center to the line to determine the intersection points.
///
/// Parameters:
///
/// * `circle` : The circle to check for intersection.
/// * `line_start` : The starting point of the line.
/// * `line_end` : The ending point of the line.
///
/// Returns an array containing exactly two points. If the line is tangent to the
/// circle, both points
/// will be identical. If the line does not intersect the circle, returns two
/// mathematically invalid
/// points (due to taking the square root of a negative number).
///
/// Examples:
///
/// ```moonbit
/// test "intersection_line_circle/secant" {
///   let circle = { c: new_point(0.0, 0.0), r: 1.0 }
///   let start = new_point(-2.0, 0.0)
///   let end = new_point(2.0, 0.0)
///   let points = intersection_line_circle(circle, start, end)
///   // Line intersects circle at (-1,0) and (1,0)
///   inspect!(points[0].x, content="-1.0")
///   inspect!(points[0].y, content="0.0")
///   inspect!(points[1].x, content="1.0")
///   inspect!(points[1].y, content="0.0")
/// }
/// 
/// test "intersection_line_circle/tangent" {
///   let circle = { c: new_point(0.0, 0.0), r: 1.0 }
///   let start = new_point(-2.0, 1.0)
///   let end = new_point(2.0, 1.0)
///   let points = intersection_line_circle(circle, start, end)
///   // Line is tangent to circle at (0,1)
///   inspect!(points[0].x, content="0.0")
///   inspect!(points[0].y, content="1.0")
///   inspect!(points[1].x, content="0.0")
///   inspect!(points[1].y, content="1.0")
/// }
/// ```
fn intersection_line_circle(c : Circle, l1 : Point, l2 : Point) -> Array[Point] {
  let dist = dis_p_to_line(c.c, l1, l2)
  if dist > c.r + eps {
    return []
  }
  let d = distance(l1, l2)
  let proj = ((c.c.x - l1.x) * (l2.x - l1.x) + (c.c.y - l1.y) * (l2.y - l1.y)) /
    (d * d)
  let closest = new_point(
    l1.x + proj * (l2.x - l1.x),
    l1.y + proj * (l2.y - l1.y),
  )
  let h = Double::sqrt(c.r * c.r - dist * dist) / d
  let offset_x = h * (l2.y - l1.y)
  let offset_y = h * (l1.x - l2.x)
  let p1 = new_point(closest.x + offset_x, closest.y + offset_y)
  let p2 = new_point(closest.x - offset_x, closest.y - offset_y)
  [p1, p2]
}

///|
/// Calculates the intersection points of two circles. Uses an analytical
/// geometry approach to find the points where two circles intersect. The
/// calculation involves finding a point on the radical line of the two circles
/// and then finding the intersection points of this line with one of the
/// circles.
///
/// Parameters:
///
/// * `circle1` : The first circle, defined by its center point and radius.
/// * `circle2` : The second circle, defined by its center point and radius.
///
/// Returns an array containing the two intersection points of the circles. If
/// the circles are tangent to each other, both points will be identical. If the
/// circles do not intersect, the function will still return two points, but they
/// may not be meaningful.
///
/// Examples:
///
/// ```moonbit
/// test "intersection_circle_circle/intersecting" {
///   let c1 = Circle::{ c: new_point(0.0, 0.0), r: 2.0 }
///   let c2 = Circle::{ c: new_point(2.0, 0.0), r: 2.0 }
///   let points = intersection_circle_circle(c1, c2)
///   // Circles intersect at (1.0, ±√3)
///   inspect!(points[0].x, content="1.0")
///   inspect!((points[0].y - 1.732050808).abs() < 0.000001, content="true")
///   inspect!(points[1].x, content="1.0")
///   inspect!((points[1].y + 1.732050808).abs() < 0.000001, content="true")
/// }
/// 
/// test "intersection_circle_circle/tangent" {
///   let c1 = Circle::{ c: new_point(0.0, 0.0), r: 1.0 }
///   let c2 = Circle::{ c: new_point(2.0, 0.0), r: 1.0 }
///   let points = intersection_circle_circle(c1, c2)
///   // Circles are tangent at (1.0, 0.0)
///   inspect!(points[0].x, content="1.0")
///   inspect!(points[0].y, content="0.0")
///   inspect!(points[1].x, content="1.0")
///   inspect!(points[1].y, content="0.0")
/// }
/// ```
fn intersection_circle_circle(c1 : Circle, c2 : Circle) -> Array[Point] {
  let u : Point = c1.c
  let v : Point = c2.c
  let t : Double = (
      1.0 +
      (c1.r * c1.r - c2.r * c2.r) / distance(c1.c, c2.c) / distance(c1.c, c2.c)
    ) /
    2.0
  u.x = c1.c.x + (c2.c.x - c1.c.x) * t
  u.y = c1.c.y + (c2.c.y - c1.c.y) * t
  v.x = u.x + c1.c.y - c2.c.y
  v.y = u.y - c1.c.x + c2.c.x
  intersection_line_circle(c1, u, v)
}
