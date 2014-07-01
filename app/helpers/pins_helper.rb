module PinsHelper
  def map_pins track
    track.pins.map do |pin|
      [pin.startpin, pin.stoppin]
    end
  end
end
