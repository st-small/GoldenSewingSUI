import MapKit

public enum MapConstants {
	public static let coordinate = CLLocationCoordinate2DMake(48.50552, 32.27031)
	public static let region = MKCoordinateRegion(
		center: coordinate,
		span: span
	)
	public static let url = URL(string: "maps://?saddr=&daddr=48.50552,32.27031")
	
	private static let span = MKCoordinateSpan(
		latitudeDelta: 10,
		longitudeDelta: 10
	)
	private static let mapItem = MKMapItem(placemark: .init(coordinate: coordinate))
}

