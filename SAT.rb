#Summed Area Table

class SAT
  attr_reader :sa, :width, :height

  def initialize(a, width, height)
    @a, @width, @height = a, width, height
    @sa = Array.new(@width*@height)
    calc
  end

  #note: all parameters >= 0, x2>=x1, y2>=y1, x1,x2 <= width-1, y1,y2<=height-1
  def getAt(x1, y1, x2, y2)
    if x1 == 0 || y1 == 0
      if x1 == 0 && y1 == 0
        return @sa[y2*@width + x2]
      elsif x1 == 0 && y1 != 0
        return @sa[y2*@width + x2] - @sa[(y1-1)*@width + x2]
      else # x1 != 0 && y1 == 0
        ty2 = y2*@width
        return @sa[ty2 + x2] - @sa[y2 + (x1 - 1)]
      end
    else
      tx1, ty1, tx2, ty2 =  x1-1, (y1-1)*@width, x2, y2*@width
      return @sa[ty2 + tx2] - @sa[ty1 + tx2] - @sa[ty2 + tx1] + @sa[ty1 + tx1]
    end
  end

  private
  def calc
    @sa[0] = @a[0]

    #first column
    c, s = 0, @a[0]
    for i in 1...@height
      c += @width
      @sa[c] = s + @a[c]
      s += @a[c]
    end

    #first row
    s = @a[0]
    for i in 1...@width
      s += @a[i]
      @sa[i] = s
    end

    #other
    for j in 1...@height
      c, r = j*@width, @a[c]
      for i in 1...@width
        k = c + i
        @sa[k] = @a[k] + @sa[k - @width] + r
        r += @a[k - 1]
      end
    end
  end

end

#test
if __FILE__ == $0
  t = Array.new(5*5) { 1 }
  a = SAT.new(t, 5, 5)

  for j in 0...5
    for i in 0...5
      print a.sa[j*5 + i]
    end
    print "\r\n"
  end

  puts a.getAt(0, 0, 0, 0) #=1
  puts a.getAt(0, 0, 0, 2) #=3
  puts a.getAt(0, 0, 2, 0) #=3
  puts a.getAt(3, 3, 4, 4) #=4
  puts a.getAt(1, 2, 3, 2) #=3
end
