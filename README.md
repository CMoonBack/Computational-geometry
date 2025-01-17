# Computational Geometry library

This repository contains a library of computational geometry implemented in Moonbit. 
The library provides a variety of correlation operations for calculating geometry, 
and is expected to cover the following areas: point-line correlation, 
polygon correlation, triangle correlation, circle correlation, 
convex hull correlation, 3D geometric correlation, etc.

## Features

### 2D geometric

#### Point and line correlation

- **cross product**: Calculates the cross product of two vectors formed by three points.
- **dot product**: Calculates the dot product of two vectors formed by three points.
- **distance**: Calculates the distance between two points.
- **collinear**: Checks whether three points are collinear.
- **on segment1**: Checks whether a point is on a line segment,including the endpoints.
- **on segment2**: Checks whether a point is on a line segment,excluding the endpoints.
- **same side**: Determines whether two points lie on the same side of a line.
- **opposite side**: Determines whether two points lie on opposite sides of a line.
- **symmetric point**: Calculates the symmetric point (reflection) of a point with respect to a line.
- **intersected**: Checks whether two line segments intersect.
- **intersected point**: Calculates the intersection point of two line segments.
- **point to line**: Calculates the projection point of a given point onto a line defined by two points.
- **distance of point to line**: Calculates the distance between a point and a line.
- **point to line segment**: Calculates the projection point of a given point onto a line segment.

#### Polygon correlation

- **is sign**: Check the sign of floating-point numbers.
- **is convex**: Check whether a polygon is convex.
- **point inside convex**: Checks whether a point is inside a convex polygon.
- **point inside polygon**: Checks whether a point is inside a polygon.
- **segment inside polygon**: Checks whether a line segment is inside a polygon.

#### Triangle correlation

- **circumcenter**: Calculates the circumcenter of a triangle.
- **incenter**: Calculates the incenter of a triangle.
- **perpencenter**: Calculates the perpencenter of a triangle.

#### Circle correlation

- **intersect_line_circle**: Checks whether a line intersects with a circle.
- **intersect_segment_circle**: Checks whether a line segment intersects with a circle.
- **intersect_circle_circle**: Checks whether two circles intersect.
- **dot_to_circle**: Checks the closest point on a circle to a given point.
- **intersection_line_circle**: Calculates the intersection points of a line and a circle.
- **intersection_circle_circle**: Calculates the intersection points of two circles.

#### Sphere correlation

- **angle**: Give the latitude and longitude of the earth and calculate the central angle of the circle.
- **line_dist**: Knowing the latitude and longitude, calculate the straight-line distance between two points on the earth.
- **sphere_dist**: Knowing the latitude and longitude, calculate the spherical distance between two points on the earth.

### 3D geometric

#### Preparatory functions

- **cross product**: Calculates the cross product of two vectors.
- **dot product**: Calculates the dot product of two vectors.
- **subtract**: Subtracts two vectors.
- **pvec plane**: Calculates the normal vector of a plane using the cross product of two vectors formed from three points on the plane.
- **pvec point**: Calculates the cross product of two vectors formed by three points in 3D space.
- **distance3d**: Calculates the distance between two points.
- **vlen**: Calculates the length of a vector.

#### Dots on

Including the determination of whether three points are collinear, 
whether four points are coplanar, whether a point lies on a segment, 
and whether a point lies on a spatial triangle.

#### Side

Including the judgment of whether 
two points are on the same side/different sides of a line segment, 
and determining whether two points are on the same side/different sides of a plane.

#### Parallel

This includes determining whether two lines are parallel, 
whether two planes are parallel, 
and whether a line and a plane are parallel.

#### Perpendicular

This includes determining whether two lines are perpendicular, 
and whether two planes are perpendicular.

#### Intersect

This includes determining whether two segments intersect, 
and whether a segment intersects with a triangle.

#### Intersection

It includes calculating the intersection of two straight lines, 
calculating the intersection of a straight line and a plane, 
and calculating the intersection of two planes.

#### Calculations

It includes calculating the distance from the point to the straight line, the distance from the calculated point to the plane, the distance from the straight line to the straight line, the cos value of the angle between two straight lines, the cos value of the angle between two square meters, and the sin value of the angle between the straight line and the plane.


## Usages

For how to use,see the [code](https://github.com/CMoonBack/Computational-geometry/tree/main/src/lib) in the repository.

Specific usages are being written.

## License

This project is licensed under the Apache-2.0 License.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Contact

For any questions or suggestions, please contact [2214559347@qq.com].
