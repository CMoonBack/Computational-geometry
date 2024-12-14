# Computational Geometry library

This repository contains a library of computational geometry implemented in Moonbit. The library provides a variety of correlation operations for calculating geometry, and is expected to cover the following areas: point-line correlation, polygon correlation, triangle correlation, circle correlation, convex hull correlation, 3D geometric correlation, etc.

At present, the algorithm of point and line correlation has been implemented, including the algorithm of some relationships between points and lines and line segments.

## Features

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
- **point to line segment**: Calculates the projection point of a given point onto a line segment.

#### Polygon correlation

- **is sign**: Check the sign of floating-point numbers.
- **is convex**: Check whether a polygon is convex.
- **point inside convex**: Checks whether a point is inside a convex polygon.
- **point inside polygon**: Checks whether a point is inside a polygon.
- **segment inside polygon**: Checks whether a line segment is inside a polygon.

## Usages

For how to use,see the [core](https://github.com/CMoonBack/Computational-geometry/tree/main/src/lib) in the repository.

Specific usages are being written.

## License

This project is licensed under the Apache-2.0 License.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Contact

For any questions or suggestions, please contact [2214559347@qq.com].
