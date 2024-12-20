///|
let offset : Int = 10000

///|
let maxn : Int = 1000

///| Determines the sign of a double-precision floating-point number, taking into
/// account a small epsilon value to handle floating-point arithmetic
/// imprecision.
///
/// Parameters:
///
/// * `value` : A double-precision floating-point number to check.
///
/// Returns an integer indicating the sign of the value:
///
/// * `0` if the absolute value is less than epsilon (effectively zero)
/// * `1` if the value is greater than epsilon (positive)
/// * `2` if the value is less than negative epsilon (negative)
///
/// Examples:
///
/// ```moonbit
/// test "is_sign/positive" {
///   inspect!(is_sign(1.0), content="1")
/// }
/// 
/// test "is_sign/negative" {
///   inspect!(is_sign(-1.0), content="2")
/// }
/// 
/// test "is_sign/zero" {
///   // Values close to zero (within ±eps) are considered zero
///   inspect!(is_sign(0.000000001), content="0")
/// }
/// ```
fn is_sign(x : Double) -> Int {
  if x > eps {
    1
  } else if x < -eps {
    2
  } else {
    0
  }
}

///| Determines whether a polygon is convex by examining the cross products of
/// consecutive vertices.
///
/// Parameters:
///
/// * `vertex_count` : An integer representing the number of vertices in the
/// polygon.
/// * `vertices` : An array of points representing the vertices of the polygon in
/// either clockwise or counterclockwise order.
///
/// Returns an integer indicating the convexity of the polygon:
///
/// * `1` if the polygon is convex (all vertices form the same turning direction)
/// * `0` if the polygon is not convex (contains both clockwise and
/// counterclockwise turns)
///
/// Example:
///
/// ```moonbit
/// test "is_convex/square" {
///   let square = [
///     new_point(0.0, 0.0),
///     new_point(1.0, 0.0),
///     new_point(1.0, 1.0),
///     new_point(0.0, 1.0),
///   ]
///   // A square is a convex polygon
///   inspect!(is_convex(4, square), content="1")
/// }
/// 
/// test "is_convex/non_convex" {
///   let arrow = [
///     new_point(0.0, 0.0),
///     new_point(2.0, 0.0),
///     new_point(1.0, 1.0),
///     new_point(2.0, 2.0),
///     new_point(0.0, 2.0),
///   ]
///   // An arrow-shaped polygon is not convex
///   inspect!(is_convex(5, arrow), content="0")
/// }
/// ```
fn is_convex(n : Int, p : Array[Point]) -> Int {
  let s : Array[Int] = [1, 1, 1]
  for i = 0; i < n && Int::lor(s[1], s[2]) == 1; i = i + 1 {
    let xmult = mul(p[(i + 1) % n], p[(i + 2) % n], p[i])
    s[is_sign(xmult)] = 0
  }
  Int::lor(s[1], s[2])
}

///| Determines whether a point lies inside a convex polygon using the cross
/// product method. A point is considered inside if it lies on the same side of
/// all edges of the polygon.
///
/// Parameters:
///
/// * `point` : The point to test for containment, represented as a `Point`
/// structure with x and y coordinates.
/// * `vertex_count` : The number of vertices in the polygon.
/// * `vertices` : An array of points representing the vertices of the convex
/// polygon in either clockwise or counterclockwise order.
///
/// Returns an integer value:
///
/// * `1` if the point lies inside the convex polygon
/// * `0` if the point lies outside the convex polygon or on its boundary
///
/// Example:
///
/// ```moonbit
/// test "point_inside_convex/inside" {
///   let square = [
///     new_point(0.0, 0.0),
///     new_point(2.0, 0.0),
///     new_point(2.0, 2.0),
///     new_point(0.0, 2.0),
///   ]
///   let point = new_point(1.0, 1.0)
///   // Point is inside the convex square
///   inspect!(point_inside_convex(point, 4, square), content="1")
/// }
/// 
/// test "point_inside_convex/outside" {
///   let triangle = [new_point(0.0, 0.0), new_point(2.0, 0.0), new_point(1.0, 2.0)]
///   let point = new_point(3.0, 1.0)
///   // Point is outside the convex triangle
///   inspect!(point_inside_convex(point, 3, triangle), content="0")
/// }
/// ```
fn point_inside_convex(q : Point, n : Int, p : Array[Point]) -> Int {
  let s : Array[Int] = [1, 1, 1]
  for i = 0; i < n && Int::lor(s[1], s[2]) == 1; i = i + 1 {
    let xmult = mul(p[(i + 1) % n], q, p[i])
    s[is_sign(xmult)] = 0
  }
  Int::lor(s[1], s[2])
}

///| Determines whether a point lies inside a polygon using the ray casting
/// algorithm (also known as the even-odd rule). A point is considered inside if
/// a ray cast from the point in any direction crosses an odd number of polygon
/// edges.
///
/// Parameters:
///
/// * `point` : The point to test for containment, represented as a `Point`
/// structure with x and y coordinates.
/// * `vertex_count` : The number of vertices in the polygon.
/// * `vertices` : An array of points representing the vertices of the polygon in
/// either clockwise or counterclockwise order.
///
/// Returns an integer value:
///
/// * `1` if the point lies inside the polygon
/// * `0` if the point lies outside the polygon or on its boundary
///
/// Examples:
///
/// ```moonbit
/// test "point_inside_polygon/inside" {
///   let square = [
///     new_point(0.0, 0.0),
///     new_point(2.0, 0.0),
///     new_point(2.0, 2.0),
///     new_point(0.0, 2.0),
///   ]
///   let point = new_point(1.0, 1.0)
///   // Point is inside the square
///   inspect!(point_inside_polygon(point, 4, square), content="1")
/// }
/// 
/// test "point_inside_polygon/outside" {
///   let triangle = [new_point(0.0, 0.0), new_point(2.0, 0.0), new_point(1.0, 2.0)]
///   let point = new_point(3.0, 3.0)
///   // Point is outside the triangle
///   inspect!(point_inside_polygon(point, 3, triangle), content="0")
/// }
/// ```
fn point_inside_polygon(q : Point, n : Int, p : Array[Point]) -> Int {
  let q2 : Point = new_point(q.x + 1, q.y)
  let mut count = 0
  for i = 0; i < n; i = i + 1 {
    let f1 : Bool = iszero(mul(q, p[i], p[(i + 1) % n]))
    let f2 : Bool = (p[i].x - q.x) * (p[(i + 1) % n].x - q.x) < eps
    let f3 : Bool = (p[i].y - q.y) * (p[(i + 1) % n].y - q.y) < eps
    if f1 && f2 && f3 {
      return 1 // 点在多边形的边上
    } else if iszero(mul(q, q2, p[i])) {
      continue
    } else {
      let f1 : Bool = mul(q, p[i], q2) * mul(q, p[(i + 1) % n], q2) < -eps
      let f2 : Bool = mul(p[i], q, p[(i + 1) % n]) *
        mul(p[i], q2, p[(i + 1) % n]) <
        -eps
      if f1 && f2 {
        count = count + 1
      }
    }
  }
  Int::land(count, 1)
}

///| Determines if a line segment lies completely inside a polygon. A line segment
/// is considered inside if both its endpoints are inside the polygon and it
/// doesn't intersect with any of the polygon's edges (except possibly at the
/// endpoints).
///
/// Parameters:
///
/// * `segment_start` : The starting point of the line segment.
/// * `segment_end` : The ending point of the line segment.
/// * `vertex_count` : The number of vertices in the polygon.
/// * `vertices` : An array of points representing the vertices of the polygon in
/// either clockwise or counterclockwise order.
///
/// Returns an integer value:
///
/// * `1` if the line segment lies completely inside the polygon
/// * `0` if any part of the line segment lies outside the polygon or intersects
/// with the polygon's edges
///
/// Examples:
///
/// ```moonbit
/// test "segment_inside_polygon/inside" {
///   let square = [
///     new_point(0.0, 0.0),
///     new_point(2.0, 0.0),
///     new_point(2.0, 2.0),
///     new_point(0.0, 2.0),
///   ]
///   let start = new_point(0.5, 0.5)
///   let end = new_point(1.5, 1.5)
///   // A diagonal line segment inside a square
///   inspect!(segment_inside_polygon(start, end, 4, square), content="1")
/// }
/// 
/// test "segment_inside_polygon/intersecting" {
///   let square = [
///     new_point(0.0, 0.0),
///     new_point(2.0, 0.0),
///     new_point(2.0, 2.0),
///     new_point(0.0, 2.0),
///   ]
///   let start = new_point(1.0, 1.0)
///   let end = new_point(3.0, 1.0)
///   // A line segment that intersects the square's edge
///   inspect!(segment_inside_polygon(start, end, 4, square), content="0")
/// }
/// ```
fn segment_inside_polygon(
  l1 : Point,
  l2 : Point,
  n : Int,
  p : Array[Point]
) -> Int {
  let tmp1 : Array[Point] = Array::make(maxn, new_point(0, 0))
  let tmp2 : Point = new_point(0, 0)
  let mut k : Int = 0
  if point_inside_polygon(l1, n, p) == 0 || point_inside_polygon(l2, n, p) == 0 {
    0
  } else {
    for i = 0; i < n; i = i + 1 {
      if opposite_side(l1, l2, new_line(p[i], p[(i + 1) % n])) == true &&
        opposite_side(p[i], p[(i + 1) % n], new_line(l1, l2)) == true {
        return 0
      } else if dot_online_in(l1, new_line(p[i], p[(i + 1) % n])) == true {
        tmp1[k] = l1
        k = k + 1
      } else if dot_online_in(l2, new_line(p[i], p[(i + 1) % n])) == true {
        tmp1[k] = l2
        k = k + 1
      } else if dot_online_in(p[i], new_line(l1, l2)) {
        tmp1[k] = p[i]
        k = k + 1
      }
    }
    for i = 0; i < k; i = i + 1 {
      for j = i + 1; j < k; j = j + 1 {
        tmp2.x = (tmp1[i].x + tmp1[j].x) / 2
        tmp2.y = (tmp1[i].y + tmp1[j].y) / 2
        if point_inside_polygon(tmp2, n, p) == 0 {
          return 0
        }
      }
    }
    1
  }
}
