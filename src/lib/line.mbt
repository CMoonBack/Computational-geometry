//A minimum value, taking into account the error of the computational geometry,
//if a certain number is less than eps, then this number is 0
///|
let eps : Double = 0.00000001

///|
fn iszero(x : Double) -> Bool {
  if x.abs() < eps {
    true
  } else {
    false
  }
}

///|
fn max(a : Double, b : Double) -> Double {
  @math.maximum(a, b)
}

///|
fn min(a : Double, b : Double) -> Double {
  @math.minimum(a, b)
}

///|
struct Point {
  mut x : Double
  mut y : Double
}

///|
fn op_eq(self : Point, other : Point) -> Bool {
  if self.x == other.x && self.y == other.y {
    true
  } else {
    false
  }
}

///|
fn op_add(self : Point, other : Point) -> Point {
  { x: self.x + other.x, y: self.y + other.y }
}

///|
fn op_sub(self : Point, other : Point) -> Point {
  { x: self.x - other.x, y: self.y - other.y }
}

///|
struct Line {
  mut a : Point
  b : Point
}

///| Calculates the cross product of two vectors formed by three points. The first
/// vector is from point `origin` to point `p1`, and the second vector is from
/// point `origin` to point `p2`. The cross product determines the relative
/// orientation of the two vectors (counterclockwise being positive, clockwise
/// being negative).
///
/// Parameters:
///
/// * `p1` : The endpoint of the first vector.
/// * `p2` : The endpoint of the second vector.
/// * `origin` : The origin point serving as the starting point of both vectors.
///
/// Returns the cross product of the two vectors. A positive value indicates a
/// counterclockwise turn, a negative value indicates a clockwise turn, and zero
/// indicates collinearity.
///
/// Examples:
///
/// ```moonbit
/// test "mul/counterclockwise" {
///   let origin = new_point(0.0, 0.0)
///   let p1 = new_point(1.0, 0.0)
///   let p2 = new_point(0.0, 1.0)
///   // Points form a counterclockwise turn
///   inspect!(mul(p1, p2, origin), content="1.0")
/// }
/// 
/// test "mul/clockwise" {
///   let origin = new_point(0.0, 0.0)
///   let p1 = new_point(0.0, 1.0)
///   let p2 = new_point(1.0, 0.0)
///   // Points form a clockwise turn
///   inspect!(mul(p1, p2, origin), content="-1.0")
/// }
/// 
/// test "mul/collinear" {
///   let origin = new_point(0.0, 0.0)
///   let p1 = new_point(1.0, 0.0)
///   let p2 = new_point(2.0, 0.0)
///   // Points are collinear
///   inspect!(mul(p1, p2, origin), content="0.0")
/// }
/// ```
fn mul(p1 : Point, p2 : Point, p0 : Point) -> Double {
  (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y)
}

///| Calculates the dot product of two vectors formed by three points. The first
/// vector is from point `origin` to point `p1`, and the second vector is from
/// point `origin` to point `p2`.
///
/// Parameters:
///
/// * `p1` : The endpoint of the first vector.
/// * `p2` : The endpoint of the second vector.
/// * `origin` : The origin point serving as the starting point of both vectors.
///
/// Returns the dot product of the two vectors.
///
/// Example:
///
/// ```moonbit
/// test "dot" {
///   let origin = new_point(0.0, 0.0)
///   let p1 = new_point(1.0, 0.0)
///   let p2 = new_point(0.0, 1.0)
///   // Vectors are perpendicular, dot product should be 0
///   inspect!(dot(p1, p2, origin), content="0.0")
///   
///   let p3 = new_point(2.0, 0.0)
///   // Vectors are parallel, dot product should be positive
///   inspect!(dot(p1, p3, origin), content="2.0")
/// }
/// 
/// test "dot/non_zero_origin" {
///   let origin = new_point(1.0, 1.0)
///   let p1 = new_point(2.0, 1.0)
///   let p2 = new_point(1.0, 2.0)
///   // Vectors are perpendicular even with non-zero origin
///   inspect!(dot(p1, p2, origin), content="0.0")
/// }
/// ```
fn dot(p1 : Point, p2 : Point, p0 : Point) -> Double {
  (p1.x - p0.x) * (p2.x - p0.x) + (p1.y - p0.y) * (p2.y - p0.y)
}

///| Calculates the Euclidean distance between two points in a 2D plane using the
/// formula √((x₁-x₂)² + (y₁-y₂)²).
///
/// Parameters:
///
/// * `first` : The first point in the 2D plane.
/// * `second` : The second point in the 2D plane.
///
/// Returns the Euclidean distance between the two points.
///
/// Examples:
///
/// ```moonbit
/// test "distance/zero" {
///   let p1 = new_point(0.0, 0.0)
///   let p2 = new_point(0.0, 0.0)
///   inspect!(distance(p1, p2), content="0.0")
/// }
/// 
/// test "distance/horizontal" {
///   let p1 = new_point(0.0, 0.0)
///   let p2 = new_point(3.0, 0.0)
///   inspect!(distance(p1, p2), content="3.0")
/// }
/// 
/// test "distance/diagonal" {
///   let p1 = new_point(0.0, 0.0)
///   let p2 = new_point(3.0, 4.0)
///   // Distance should be 5.0 (3-4-5 triangle)
///   inspect!(distance(p1, p2), content="5.0")
/// }
/// ```
fn distance(p1 : Point, p2 : Point) -> Double {
  Double::sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
}

///| Determines if three points are collinear (lie on the same straight line).
///
/// Parameters:
///
/// * `point1` : The first point.
/// * `point2` : The second point.
/// * `point3` : The third point.
///
/// Returns `true` if the three points are collinear, `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "dots_inline/collinear" {
///   let p1 = new_point(1.0, 1.0)
///   let p2 = new_point(2.0, 2.0)
///   let p3 = new_point(3.0, 3.0)
///   // Points lying on the line y = x
///   inspect!(dots_inline(p1, p2, p3), content="true")
/// }
/// 
/// test "dots_inline/non_collinear" {
///   let p1 = new_point(0.0, 0.0)
///   let p2 = new_point(1.0, 0.0)
///   let p3 = new_point(0.0, 1.0)
///   // Points forming a right triangle
///   inspect!(dots_inline(p1, p2, p3), content="false")
/// }
/// 
/// test "dots_inline/duplicate_points" {
///   let p1 = new_point(1.0, 1.0)
///   let p2 = new_point(1.0, 1.0)
///   let p3 = new_point(1.0, 1.0)
///   // Duplicate points are considered collinear
///   inspect!(dots_inline(p1, p2, p3), content="true")
/// }
/// ```
fn dots_inline(p1 : Point, p2 : Point, p3 : Point) -> Bool {
  iszero(mul(p1, p2, p3))
}

///| Determines whether a point lies on a line segment, including the endpoints. A
/// point is considered to be on the line segment if it is collinear with the
/// segment's endpoints and its coordinates lie within the segment's bounds.
///
/// Parameters:
///
/// * `point` : The point to be checked.
/// * `segment` : A line segment defined by two endpoints.
///
/// Returns `true` if the point lies on the line segment (including endpoints),
/// `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "dot_online_in/on_segment" {
///   let p = new_point(2.0, 2.0)
///   let segment = new_line(new_point(1.0, 1.0), new_point(3.0, 3.0))
///   // Point lies on the middle of the segment
///   inspect!(dot_online_in(p, segment), content="true")
/// }
/// 
/// test "dot_online_in/at_endpoint" {
///   let p = new_point(1.0, 1.0)
///   let segment = new_line(new_point(1.0, 1.0), new_point(3.0, 3.0))
///   // Point is at the segment's endpoint
///   inspect!(dot_online_in(p, segment), content="true")
/// }
/// 
/// test "dot_online_in/off_segment" {
///   let p = new_point(0.0, 0.0)
///   let segment = new_line(new_point(1.0, 1.0), new_point(3.0, 3.0))
///   // Point is collinear but not on the segment
///   inspect!(dot_online_in(p, segment), content="false")
/// }
/// 
/// test "dot_online_in/not_collinear" {
///   let p = new_point(2.0, 1.0)
///   let segment = new_line(new_point(1.0, 1.0), new_point(3.0, 3.0))
///   // Point is not collinear with the segment
///   inspect!(dot_online_in(p, segment), content="false")
/// }
/// ```
fn dot_online_in(p : Point, l : Line) -> Bool {
  let f1 : Bool = iszero(mul(p, l.a, l.b))
  let f2 : Bool = (l.a.x - p.x) * (l.b.x - p.x) < eps
  let f3 : Bool = (l.a.y - p.y) * (l.b.y - p.y) < eps
  f1 && f2 && f3
}

///| Determines whether a point lies strictly on a line segment, excluding the
/// endpoints. A point is considered to be strictly on the line segment if it is
/// collinear with the segment's endpoints and lies between them, but is not
/// equal to either endpoint.
///
/// Parameters:
///
/// * `point` : The point to be checked.
/// * `segment` : A line segment defined by two endpoints.
///
/// Returns `true` if the point lies strictly on the line segment (excluding
/// endpoints), `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "dot_online_ex/on_segment" {
///   let p = new_point(2.0, 2.0)
///   let segment = new_line(new_point(1.0, 1.0), new_point(3.0, 3.0))
///   // Point lies strictly on the middle of the segment
///   inspect!(dot_online_ex(p, segment), content="true")
/// }
/// 
/// test "dot_online_ex/at_endpoint" {
///   let p = new_point(1.0, 1.0)
///   let segment = new_line(new_point(1.0, 1.0), new_point(3.0, 3.0))
///   // Point is at the segment's endpoint, should return false
///   inspect!(dot_online_ex(p, segment), content="false")
/// }
/// 
/// test "dot_online_ex/off_segment" {
///   let p = new_point(0.0, 0.0)
///   let segment = new_line(new_point(1.0, 1.0), new_point(3.0, 3.0))
///   // Point is collinear but not on the segment
///   inspect!(dot_online_ex(p, segment), content="false")
/// }
/// 
/// test "dot_online_ex/not_collinear" {
///   let p = new_point(2.0, 1.0)
///   let segment = new_line(new_point(1.0, 1.0), new_point(3.0, 3.0))
///   // Point is not collinear with the segment
///   inspect!(dot_online_ex(p, segment), content="false")
/// }
/// ```
fn dot_online_ex(p : Point, l : Line) -> Bool {
  let f1 : Bool = dot_online_in(p, l)
  let f2 : Bool = not(iszero(p.x - l.a.x)) || not(iszero(p.y - l.a.y))
  let f3 : Bool = not(iszero(p.x - l.b.x)) || not(iszero(p.y - l.b.y))
  f1 && f2 && f3
}

///| Determines whether two points lie on the same side of a line. Points are
/// considered to be on the same side if the cross products of vectors formed
/// from the line segment's endpoints to each point have the same sign.
///
/// Parameters:
///
/// * `point1` : The first point to check.
/// * `point2` : The second point to check.
/// * `line` : The line segment that serves as the divider.
///
/// Returns `true` if both points lie on the same side of the line segment,
/// `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "same_side/same_side" {
///   let p1 = new_point(0.0, 1.0)
///   let p2 = new_point(1.0, 1.0)
///   let line = new_line(new_point(-1.0, 0.0), new_point(1.0, 0.0))
///   // Points are on the same side (above) of the horizontal line
///   inspect!(same_side(p1, p2, line), content="true")
/// }
/// 
/// test "same_side/opposite_sides" {
///   let p1 = new_point(0.0, 1.0)
///   let p2 = new_point(0.0, -1.0)
///   let line = new_line(new_point(-1.0, 0.0), new_point(1.0, 0.0))
///   // Points are on opposite sides of the horizontal line
///   inspect!(same_side(p1, p2, line), content="false")
/// }
/// 
/// test "same_side/point_on_line" {
///   let p1 = new_point(0.0, 0.0)
///   let p2 = new_point(1.0, 1.0)
///   let line = new_line(new_point(-1.0, 0.0), new_point(1.0, 0.0))
///   // One point lies on the line
///   inspect!(same_side(p1, p2, line), content="false")
/// }
/// ```
fn same_side(p1 : Point, p2 : Point, l : Line) -> Bool {
  mul(l.a, p1, l.b) * mul(l.a, p2, l.b) > eps
}

///| Determines whether two points lie on opposite sides of a line segment. Points
/// are considered to be on opposite sides if the cross products of vectors
/// formed from the line segment's endpoints to each point have different signs.
///
/// Parameters:
///
/// * `point1` : The first point to check.
/// * `point2` : The second point to check.
/// * `segment` : The line segment that serves as the divider.
///
/// Returns `true` if the points lie on opposite sides of the line segment,
/// `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "opposite_side/basic" {
///   let p1 = new_point(0.0, 1.0)
///   let p2 = new_point(0.0, -1.0)
///   let line = new_line(new_point(-1.0, 0.0), new_point(1.0, 0.0))
///   // Points are on opposite sides of the horizontal line
///   inspect!(opposite_side(p1, p2, line), content="true")
/// }
/// 
/// test "opposite_side/same_side" {
///   let p1 = new_point(0.0, 1.0)
///   let p2 = new_point(1.0, 1.0)
///   let line = new_line(new_point(-1.0, 0.0), new_point(1.0, 0.0))
///   // Points are on the same side of the horizontal line
///   inspect!(opposite_side(p1, p2, line), content="false")
/// }
/// 
/// test "opposite_side/point_on_line" {
///   let p1 = new_point(0.0, 0.0)
///   let p2 = new_point(0.0, 1.0)
///   let line = new_line(new_point(-1.0, 0.0), new_point(1.0, 0.0))
///   // One point lies on the line
///   inspect!(opposite_side(p1, p2, line), content="false")
/// }
/// ```
fn opposite_side(p1 : Point, p2 : Point, l : Line) -> Bool {
  mul(l.a, p1, l.b) * mul(l.a, p2, l.b) < -eps
}

///| Calculates the symmetric point (reflection) of a point with respect to a line
/// defined by two points. The symmetric point is the mirror image of the
/// original point across the line.
///
/// Parameters:
///
/// * `point` : The point to be reflected.
/// * `line_start` : The first point defining the line of symmetry.
/// * `line_end` : The second point defining the line of symmetry.
///
/// Returns a new point that is symmetric to the input point with respect to the
/// line.
///
/// Examples:
///
/// ```moonbit
/// test "symmetric_point/vertical_line" {
///   let point = new_point(1.0, 2.0)
///   let line_start = new_point(3.0, 0.0)
///   let line_end = new_point(3.0, 4.0)
///   // Reflection across a vertical line x = 3
///   let result = symmetric_point(point, line_start, line_end)
///   inspect!(result.x, content="5.0")
///   inspect!(result.y, content="2.0")
/// }
/// 
/// test "symmetric_point/slanted_line" {
///   let point = new_point(0.0, 0.0)
///   let line_start = new_point(1.0, 1.0)
///   let line_end = new_point(2.0, 2.0)
///   // Reflection across the line y = x
///   let result = symmetric_point(point, line_start, line_end)
///   inspect!(result.x, content="0.0")
///   inspect!(result.y, content="0.0")
/// }
/// ```
fn symmetric_point(p1 : Point, l1 : Point, l2 : Point) -> Point {
  let mut rx : Double = 0
  let mut ry : Double = 0
  if l1.x > l2.x - eps && l1.x < l2.x + eps {
    rx = l1.x * 2 - p1.x
    ry = p1.y
  } else {
    let k : Double = (l1.y - l2.y) / (l1.x - l2.x)
    rx = (k * k * l1.x * 2 + k * p1.y * 2 - k * l1.y * 2 - k * k * p1.x + p1.x) /
      (k * k + 1)
    ry = p1.y - (rx - p1.x) / k
  }
  new_point(rx, ry)
}

///| Determines whether two line segments intersect. Uses the concept of cross
/// products and bounding boxes to efficiently check for intersection.
///
/// Parameters:
///
/// * `start1`, `end1`: The start and end points of the first line segment.
/// * `start2`, `end2`: The start and end points of the second line segment.
///
/// Returns `true` if the line segments intersect, `false` otherwise.
///
/// Examples:
///
/// ```moonbit
/// test "isIntersected/crossing" {
///   let s1 = new_point(0.0, 0.0)
///   let e1 = new_point(2.0, 2.0)
///   let s2 = new_point(0.0, 2.0)
///   let e2 = new_point(2.0, 0.0)
///   // Two segments crossing at (1.0, 1.0)
///   inspect!(isIntersected(s1, e1, s2, e2), content="true")
/// }
/// 
/// test "isIntersected/parallel" {
///   let s1 = new_point(0.0, 0.0)
///   let e1 = new_point(2.0, 0.0)
///   let s2 = new_point(0.0, 1.0)
///   let e2 = new_point(2.0, 1.0)
///   // Two parallel horizontal segments
///   inspect!(isIntersected(s1, e1, s2, e2), content="false")
/// }
/// 
/// test "isIntersected/touching" {
///   let s1 = new_point(0.0, 0.0)
///   let e1 = new_point(1.0, 1.0)
///   let s2 = new_point(1.0, 1.0)
///   let e2 = new_point(2.0, 2.0)
///   // Two segments touching at endpoints
///   inspect!(isIntersected(s1, e1, s2, e2), content="true")
/// }
/// ```
fn isIntersected(s1 : Point, e1 : Point, s2 : Point, e2 : Point) -> Bool {
  let f1 : Bool = max(s1.x, e1.x) >= min(s2.x, e2.x)
  let f2 : Bool = max(s2.x, e2.x) >= min(s1.x, e1.x)
  let f3 : Bool = max(s1.y, e1.y) >= min(s2.y, e2.y)
  let f4 : Bool = max(s2.y, e2.y) >= min(s1.y, e1.y)
  let f5 : Bool = mul(s2, e1, s1) * mul(e1, e2, s1) <= eps
  let f6 : Bool = mul(s1, e2, s2) * mul(e2, e1, s2) <= eps
  f1 && f2 && f3 && f4 && f5 && f6
}

///| Calculates the intersection point of two line segments defined by their
/// endpoints. Uses parametric form of line equations to find the exact point
/// where the lines intersect.
///
/// Parameters:
///
/// * `segment1_start`, `segment1_end` : The start and end points of the first
/// line segment.
/// * `segment2_start`, `segment2_end` : The start and end points of the second
/// line segment.
///
/// Returns the point of intersection between the two line segments.
///
/// Examples:
///
/// ```moonbit
/// test "intersection/perpendicular" {
///   // Two perpendicular lines intersecting at (1.0, 1.0)
///   let s1 = new_point(0.0, 0.0)
///   let e1 = new_point(2.0, 2.0)
///   let s2 = new_point(0.0, 2.0)
///   let e2 = new_point(2.0, 0.0)
///   let result = intersection(s1, e1, s2, e2)
///   inspect!(result.x, content="1.0")
///   inspect!(result.y, content="1.0")
/// }
/// 
/// test "intersection/angled" {
///   // Two lines intersecting at a 45-degree angle
///   let s1 = new_point(0.0, 0.0)
///   let e1 = new_point(2.0, 0.0)
///   let s2 = new_point(1.0, -1.0)
///   let e2 = new_point(1.0, 1.0)
///   let result = intersection(s1, e1, s2, e2)
///   inspect!(result.x, content="1.0")
///   inspect!(result.y, content="0.0")
/// }
/// ```
fn intersection(u1 : Point, u2 : Point, v1 : Point, v2 : Point) -> Point {
  let mut rx : Double = u1.x
  let mut ry : Double = u1.y
  let t1 : Double = (u1.x - v1.x) * (v1.y - v2.y) -
    (u1.y - v1.y) * (v1.x - v2.x)
  let t2 : Double = (u1.x - u2.x) * (v1.y - v2.y) -
    (u1.y - u2.y) * (v1.x - v2.x)
  let t : Double = t1 / t2
  rx = rx + (u2.x - u1.x) * t
  ry = ry + (u2.y - u1.y) * t
  new_point(rx, ry)
}

///| Calculates the projection point of a given point onto a line defined by two
/// points. The projection point is the point on the line that is closest to the
/// given point, forming a perpendicular line from the original point to the
/// line.
///
/// Parameters:
///
/// * `point` : The point to be projected onto the line.
/// * `line_start` : The first point defining the line.
/// * `line_end` : The second point defining the line.
///
/// Returns the projection point on the line that is closest to the input point.
///
/// Examples:
///
/// ```moonbit
/// test "p_to_line/horizontal" {
///   let point = new_point(2.0, 2.0)
///   let line_start = new_point(0.0, 0.0)
///   let line_end = new_point(4.0, 0.0)
///   // Project point onto horizontal line
///   let result = p_to_line(point, line_start, line_end)
///   inspect!(result.x, content="2.0")
///   inspect!(result.y, content="0.0")
/// }
/// 
/// test "p_to_line/vertical" {
///   let point = new_point(2.0, 3.0)
///   let line_start = new_point(4.0, 0.0)
///   let line_end = new_point(4.0, 5.0)
///   // Project point onto vertical line
///   let result = p_to_line(point, line_start, line_end)
///   inspect!(result.x, content="4.0")
///   inspect!(result.y, content="3.0")
/// }
/// 
/// test "p_to_line/diagonal" {
///   let point = new_point(0.0, 2.0)
///   let line_start = new_point(0.0, 0.0)
///   let line_end = new_point(2.0, 2.0)
///   // Project point onto diagonal line
///   let result = p_to_line(point, line_start, line_end)
///   inspect!(result.x, content="1.0")
///   inspect!(result.y, content="1.0")
/// }
/// ```
fn p_to_line(p : Point, l1 : Point, l2 : Point) -> Point {
  let mut rx : Double = p.x
  let mut ry : Double = p.y
  rx = rx + l1.y - l2.y
  ry = ry + l2.x - l1.x
  let r : Point = new_point(rx, ry)
  intersection(p, r, l1, l2)
}

///|
/// Calculates the shortest distance from a point to a line defined by two
/// points. Uses vector operations and the intersection point to determine the
/// perpendicular distance.
///
/// Parameters:
///
/// * `point` : The point from which to calculate the distance.
/// * `line_start` : The first point defining the line.
/// * `line_end` : The second point defining the line.
///
/// Returns the perpendicular distance from the point to the line.
///
/// Examples:
///
/// ```moonbit
/// test "dis_p_to_line/vertical" {
///   let point = new_point(2.0, 1.0)
///   let line_start = new_point(0.0, 0.0)
///   let line_end = new_point(0.0, 2.0)
///   // Distance from point to vertical line
///   inspect!(dis_p_to_line(point, line_start, line_end), content="2.0")
/// }
/// 
/// test "dis_p_to_line/diagonal" {
///   let point = new_point(0.0, 2.0)
///   let line_start = new_point(0.0, 0.0)
///   let line_end = new_point(2.0, 2.0)
///   // Distance from point to diagonal line (45 degrees)
///   inspect!(dis_p_to_line(point, line_start, line_end), content="1.414214")
/// }
/// ```
fn dis_p_to_line(p : Point, l1 : Point, l2 : Point) -> Double {
  let mut rx : Double = p.x
  let mut ry : Double = p.y
  rx = rx + l1.y - l2.y
  ry = ry + l2.x - l1.x
  let r : Point = new_point(rx, ry)
  let ans : Point = intersection(p, r, l1, l2)
  distance(p, ans)
}

///| Calculates the closest point on a line segment to a given point. The result
/// is either the projection of the point onto the line segment (if the
/// projection falls within the segment) or one of the segment's endpoints (if
/// the projection falls outside the segment).
///
/// Parameters:
///
/// * `point` : The point for which to find the closest point on the line
/// segment.
/// * `segment_start` : The starting point of the line segment.
/// * `segment_end` : The ending point of the line segment.
///
/// Returns the point on the line segment that is closest to the input point.
///
/// Examples:
///
/// ```moonbit
/// test "p_to_seg/projection_inside" {
///   let point = new_point(1.0, 1.0)
///   let seg_start = new_point(0.0, 0.0)
///   let seg_end = new_point(2.0, 0.0)
///   // Point projects onto the middle of the segment
///   let result = p_to_seg(point, seg_start, seg_end)
///   inspect!(result.x, content="1.0")
///   inspect!(result.y, content="0.0")
/// }
/// 
/// test "p_to_seg/endpoint" {
///   let point = new_point(3.0, 1.0)
///   let seg_start = new_point(0.0, 0.0)
///   let seg_end = new_point(2.0, 0.0)
///   // Point projects beyond segment, closest point is segment end
///   let result = p_to_seg(point, seg_start, seg_end)
///   inspect!(result.x, content="2.0")
///   inspect!(result.y, content="0.0")
/// }
/// 
/// test "p_to_seg/vertical" {
///   let point = new_point(1.0, 2.0)
///   let seg_start = new_point(0.0, 0.0)
///   let seg_end = new_point(0.0, 4.0)
///   // Point projects onto vertical segment
///   let result = p_to_seg(point, seg_start, seg_end)
///   inspect!(result.x, content="0.0")
///   inspect!(result.y, content="2.0")
/// }
/// ```
fn p_to_seg(p : Point, l1 : Point, l2 : Point) -> Point {
  let mut rx : Double = p.x
  let mut ry : Double = p.y
  rx = rx + l1.y - l2.y
  ry = ry + l2.x - l1.x
  let r : Point = new_point(rx, ry)
  let mut ans : Point = new_point(0, 0)
  if mul(l1, r, p) * mul(l2, r, p) > eps {
    if distance(p, l1) < distance(p, l2) {
      ans = l1
    } else {
      ans = l2
    }
  } else {
    ans = intersection(p, r, l1, l2)
  }
  ans
}

///| Creates a new point in a 2D coordinate system with the specified x and y
/// coordinates.
///
/// Parameters:
///
/// * `x` : The x-coordinate of the point.
/// * `y` : The y-coordinate of the point.
///
/// Returns a `Point` struct containing the specified coordinates.
///
/// Examples:
///
/// ```moonbit
/// test "new_point" {
///   let p = new_point(1.0, 2.0)
///   inspect!(p.x, content="1.0")
///   inspect!(p.y, content="2.0")
/// }
/// 
/// test "new_point/negative_coordinates" {
///   let p = new_point(-3.0, -4.0)
///   inspect!(p.x, content="-3.0")
///   inspect!(p.y, content="-4.0")
/// }
/// 
/// test "new_point/zero_coordinates" {
///   let p = new_point(0.0, 0.0)
///   inspect!(p.x, content="0.0")
///   inspect!(p.y, content="0.0")
/// }
/// ```
pub fn new_point(x_ : Double, y_ : Double) -> Point {
  let ans = { x: x_, y: y_ }
  ans
}

///| Creates a new line segment in a 2D coordinate system defined by two
/// endpoints.
///
/// Parameters:
///
/// * `start_point` : The starting point of the line segment.
/// * `end_point` : The ending point of the line segment.
///
/// Returns a `Line` struct representing the line segment between the two points.
///
/// Examples:
///
/// ```moonbit
/// test "new_line/horizontal" {
///   let start = new_point(0.0, 0.0)
///   let end = new_point(3.0, 0.0)
///   let line = new_line(start, end)
///   inspect!(line.a.x, content="0.0")
///   inspect!(line.a.y, content="0.0")
///   inspect!(line.b.x, content="3.0")
///   inspect!(line.b.y, content="0.0")
/// }
/// 
/// test "new_line/vertical" {
///   let start = new_point(1.0, 0.0)
///   let end = new_point(1.0, 4.0)
///   let line = new_line(start, end)
///   inspect!(line.a.x, content="1.0")
///   inspect!(line.a.y, content="0.0")
///   inspect!(line.b.x, content="1.0")
///   inspect!(line.b.y, content="4.0")
/// }
/// 
/// test "new_line/diagonal" {
///   let start = new_point(-1.0, -1.0)
///   let end = new_point(1.0, 1.0)
///   let line = new_line(start, end)
///   inspect!(line.a.x, content="-1.0")
///   inspect!(line.a.y, content="-1.0")
///   inspect!(line.b.x, content="1.0")
///   inspect!(line.b.y, content="1.0")
/// }
/// ```
pub fn new_line(a_ : Point, b_ : Point) -> Line {
  let ans : Line = { a: a_, b: b_ }
  ans
}

///|
fn main {
  let a = new_point(0, 0)
  let b = new_point(1, 1)
  let c = new_point(0, 0)
  let d = new_point(2, 2)
  println(isIntersected(a, b, c, d))
  // let num : Double = eps / 2
  // let l1 = new_line(a, c)
  // println(iszero(num))
  // println(mul(a, b, c))
  // println(dot(a, b, c))
  // println(distance(a, d))
  // println(dots_inline(a, b, c))
  // println(dot_online_in(a, l1))
  // println(dot_online_ex(a, l1))
}
