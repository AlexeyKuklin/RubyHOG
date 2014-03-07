require 'RMagick'
include Magick

class HOG
  def initialize
    @kBins = 9
    @kCellSize = 8
  end   
  
  def loadImg(image)
    img = Image.read(image).first
    pix = img.export_pixels(0, 0, img.columns, img.rows, 'I')

    pix.map! { |p| p/257 }

    return {:pix => pix, :columns => img.columns, :rows => img.rows}
  end


  def getBin(angle)
    angle += Math::PI if angle < 0
    return (angle * @kBins / Math::PI).floor
  end

  def calcGrad(pix, columns, rows)

    vec = []

    for y in 0...rows
      c = y*columns
      for x in 0...columns
        prevX = (x == 0) ? 0 : pix[c - 1]
        nextX = (x == columns-1) ? 0 : pix[c + 1]
        prevY = (y == 0) ? 0 : pix[c - columns]
        nextY = (y == rows-1) ? 0 : pix[c + columns]

        #kernel[-1 0 1]
        gradX = nextX - prevX
        gradY = nextY - prevY

        mag = Math.sqrt(gradX*gradX + gradY*gradY)
        angle = Math.atan2(gradY, gradX)
        vec.push([mag, getBin(angle)])

        c += 1
      end
    end

    return vec

  end


  def getHistogram(histogram, vectors, x, y)
    for i in 0...@kCellSize
      for j in 0...@kCellSize
        val = vectors[y*@kCellSize + i + x + j][0]
      end
    end

    #GradVec* v = &vectors[y*kCellSize + i + x + j];
  end

end

h = HOG.new
t = h.loadImg('2.png')
h.calcGrad(t[:pix], t[:columns], t[:rows])


#pix.each_with_index { |e, i|
#  x = i % img.columns
#  y = i / img.columns
#  puts i, x, y
#}

exit
