///|
/// Calculates the central angle (in radians) between two points on a sphere
/// using their longitude and latitude coordinates. The calculation uses the
/// spherical law of cosines formula to determine the angle between two points on
/// the surface of a sphere.
///
/// Parameters:
///
/// * `longitude1` : The longitude of the first point in degrees.
/// * `latitude1` : The latitude of the first point in degrees.
/// * `longitude2` : The longitude of the second point in degrees.
/// * `latitude2` : The latitude of the second point in degrees.
///
/// Returns the central angle between the two points in radians.
///
/// Examples:
///
/// ```moonbit
/// test "angle/same_point" {
///   // Same point should return 0 angle
///   inspect!(angle(0.0, 0.0, 0.0, 0.0), content="0.0")
/// }
/// 
/// test "angle/antipodal" {
///   // Antipodal points (opposite sides of sphere) should return π radians
///   inspect!(angle(0.0, 90.0, 0.0, -90.0), content="3.141592653589793")
/// }
/// 
/// test "angle/equator" {
///   // Two points on equator, 90 degrees apart
///   inspect!(angle(0.0, 0.0, 90.0, 0.0), content="1.5707963267948966")
/// }
/// ```
fn angle(lng1 : Double, lat1 : Double, lng2 : Double, lat2 : Double) -> Double {
    let mut dlng : Double = Double::abs(lng2 - lng1) * @math.PI / 180.0
    while dlng >= @math.PI * 2.0 {
        dlng -= @math.PI * 2.0
    }
    if dlng > @math.PI {
        dlng = @math.PI * 2.0 - dlng
    }
    let lat11 : Double = lat1 * @math.PI / 180.0
    let lat22 : Double = lat2 * @math.PI / 180.0
    @math.acos(@math.sin(lat11) * @math.sin(lat22) + @math.cos(lat11) * @math.cos(lat22) * @math.cos(dlng))
}

///|
/// Calculates the straight-line (chord) distance between two points on a sphere,
/// given their coordinates in longitude and latitude. This function uses the
/// geometric formula for chord length instead of the great-circle distance,
/// making it useful for determining the direct "through-the-sphere" distance.
///
/// Parameters:
///
/// * `radius` : The radius of the sphere.
/// * `longitude1` : The longitude of the first point in degrees.
/// * `latitude1` : The latitude of the first point in degrees.
/// * `longitude2` : The longitude of the second point in degrees.
/// * `latitude2` : The latitude of the second point in degrees.
///
/// Returns the straight-line distance between the two points through the sphere.
///
/// Examples:
///
/// ```moonbit
/// test "line_dist/same_point" {
///   // Distance between the same point should be 0
///   let r = 6371.0 // Earth's radius in kilometers
///   inspect!(line_dist(r, 0.0, 0.0, 0.0, 0.0), content="0.0")
/// }
/// 
/// test "line_dist/antipodal" {
///   // Distance between antipodal points should be 2 * radius
///   let r = 6371.0
///   let dist = line_dist(r, 0.0, 90.0, 0.0, -90.0)
///   inspect!(Double::abs(dist - 2.0 * r) < 0.001, content="true")
/// }
/// ```
fn line_dist(r : Double, lng1 : Double, lat1 : Double, lng2 : Double, lat2 : Double) -> Double {
    let mut dlng : Double = Double::abs(lng2 - lng1) * @math.PI / 180.0
    while dlng >= @math.PI * 2.0 {
        dlng -= @math.PI * 2.0
    }
    if dlng > @math.PI {
        dlng = @math.PI * 2.0 - dlng
    }
    let lat11 : Double = lat1 * @math.PI / 180.0
    let lat22 : Double = lat2 * @math.PI / 180.0
    r * Double::sqrt(2.0 - 2.0 * (@math.cos(lat11) * @math.cos(lat22) * @math.cos(dlng) + @math.sin(lat11) * @math.sin(lat22)))
}

///|
/// Calculates the great-circle distance between two points on a sphere using
/// their longitude and latitude coordinates. The great-circle distance
/// represents the shortest distance between two points along the surface of a
/// sphere.
///
/// Parameters:
///
/// * `radius` : The radius of the sphere.
/// * `longitude1` : The longitude of the first point in degrees.
/// * `latitude1` : The latitude of the first point in degrees.
/// * `longitude2` : The longitude of the second point in degrees.
/// * `latitude2` : The latitude of the second point in degrees.
///
/// Returns the great-circle distance between the two points on the sphere's
/// surface.
///
/// Example:
///
/// ```moonbit
/// test "sphere_dist" {
///   // Calculate distance between two points on Earth (radius ≈ 6371 km)
///   // New York (40.7128°N, 74.0060°W) to London (51.5074°N, 0.1278°W)
///   let dist = sphere_dist(6371.0, -74.0060, 40.7128, -0.1278, 51.5074)
///   // Distance should be approximately 5570 km
///   inspect!(dist > 5569.0 && dist < 5571.0, content="true")
/// }
/// ```
fn sphere_dist(r : Double, lng1 : Double, lat1 : Double, lng2 : Double, lat2 : Double) -> Double {
    r * angle(lng1, lat1, lng2, lat2)
}