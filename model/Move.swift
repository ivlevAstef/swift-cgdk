public class Move { // это именно класс - чтобы можно было его изменить по ссылке
  var action: ActionType = .unknown
  var group: Int = 0
  var left: Double = 0.0
  var top: Double = 0.0
  var right: Double = 0.0
  var bottom: Double = 0.0
  var x: Double = 0.0
  var y: Double = 0.0
  var angle: Double = 0.0
  var factor: Double = 0.0
  var maxSpeed: Double = 0.0
  var maxAngularSpeed: Double = 0.0
  var vehicleType: VehicleType = .unknown
  var facilityId: Int64 = -1

  public init() {}
}
