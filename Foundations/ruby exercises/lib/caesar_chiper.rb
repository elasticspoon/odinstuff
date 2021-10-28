def caesar_cipher(input_string, shift)
  input_string.chars.map { |char| shift_letter(char, shift) }.join('')
end

def shift_letter(char, shift)
  if char.ord >= 97 && char.ord <= 122
    charBase = 97
  elsif char.ord >= 65 && char.ord <= 90
    charBase = 65
  else
    return char
  end

  ((char.ord - charBase + shift) % 26 + charBase).chr
end
