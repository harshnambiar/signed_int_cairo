#[derive(Copy, Drop, Serde)]
struct Signed {
	sign: bool,
	value: u32,
}

trait SignedTrait {
	fn toSigned(s: bool, v: u32) -> Signed;
	fn valueSigned(s: Signed) -> u32;
	fn signSigned(s: Signed) -> bool;
	fn reverseSigned(s: Signed) -> Signed;
	fn addSigned(s1: Signed, s2: Signed) -> Signed;
	fn subtractSigned(s1: Signed, s2: Signed) -> Signed;
	fn multiplySigned(s1: Signed, s2: Signed) -> Signed;
	fn divideSigned(s1: Signed, s2: Signed) -> Signed;
	fn compareSigned(s1: Signed, s2: Signed) -> u32;
	fn powerSigned(s: Signed, k: u32) -> Signed;
	fn leftShiftSigned(s: Signed, n: u32) -> Signed;
	fn rightShiftSigned(s: Signed, n: u32) -> Signed;
}


impl SignedImpl of SignedTrait {
	fn toSigned(s: bool, v: u32) -> Signed {
		let sn = Signed {
			sign: s,
			value: v,
		};
		return sn;
	}

	fn valueSigned(s: Signed) -> u32 {
		s.value
	}

	fn signSigned(s: Signed) -> bool {
		s.sign
	}

	fn reverseSigned(s: Signed) -> Signed {
		let sn = Signed {
			sign: !s.sign,
			value: s.value,
		};
		return sn;
	}

	fn addSigned(s1: Signed, s2: Signed) -> Signed {
		if s1.sign == s2.sign {
			let sn = Signed {
				sign: s1.sign,
				value: s1.value+s2.value,
			};
			return sn;
		}
		else {
			if (s1.value > s2.value){
				let sn = Signed {
					sign: s1.sign,
					value: s1.value-s2.value,
				};
				return sn;
			}
			else {
				let sn = Signed {
					sign: s2.sign,
					value: s2.value-s1.value,
				};
				return sn;
			}
		}
	}

	fn subtractSigned(s1: Signed, s2: Signed) -> Signed {
		if s1.sign != s2.sign {
			let sn = Signed {
				sign: s1.sign,
				value: s1.value+s2.value,
			};
			return sn;
		}
		else {
			if (s1.value > s2.value){
				let sn = Signed {
					sign: s1.sign,
					value: s1.value-s2.value,
				};
				return sn;
			}
			else {
				let sn = Signed {
					sign: s2.sign,
					value: s2.value-s1.value,
				};
				return sn;
			}
		}
	}

	fn multiplySigned(s1: Signed, s2: Signed) -> Signed {
		let sn = Signed {
			sign: (s1.sign == s2.sign),
			value: s1.value*s2.value,
		};
		return sn;
	}


	fn divideSigned(s1: Signed, s2: Signed) -> Signed {
		assert (s2.value != 0, 'denominator cant be 0');
		let sn = Signed {
			sign: (s1.sign == s2.sign),
			value: s1.value/s2.value,
		};
		return sn;
	}

	// if a > b return 1
	// if a < b return 2
	// if a == b return 0
	fn compareSigned(s1: Signed, s2: Signed) -> u32 {
		if ((s1.value == s2.value) && (s1.value == 0)){
			return 0;
		}
		else {
			if (s1.sign != s2.sign){
				if (s1.sign){
					return 1;
				}
				else {
					return 2;
				}
			}
			else {
				
				if (s1.value > s2.value){
					if (s1.sign){
						return 1;
					}
					else {
						return 2;
					}
				}
				else {
					if (s1.value != s2.value){
						if (s1.sign){
							return 2;
						}
						else {
							return 1;
						}
					}
					else {
						return 0;
					}
					
				}
				
			}
		}
		
	}

	fn powerSigned(s: Signed, k: u32) -> Signed {
		assert (k > 0, 'exponent needs to be positive');
		let mut val = 1;
		let mut i = 1;
		loop {
			if i == (k+1) {
				break;
			}
			val = val * s.value;
			i += 1;
		};
		
		let sn = Signed {
			sign: ((k % 2 == 0) || (s.sign)),
			value: val,
		};
		return sn;
	}

	fn leftShiftSigned(s: Signed, n: u32) -> Signed {
		let mut pow = 1;
		let mut i = 0;
		loop {
			if i >= n {
				break;
			}
			pow = pow * 2;
			i += 1;
		};
		if n == 0 {
			return s;
		}
		else {
			let sn = Signed {
				sign: s.sign,
				value: s.value * pow,
			};
			return sn;
		}
		
	}

	fn rightShiftSigned(s: Signed, n: u32) -> Signed {
		let mut pow = 1;
		let mut i = 0;
		loop {
			if i >= n {
				break;
			}
			pow = pow * 2;
			i += 1;
		};
		let mut val_final = s.value/pow;
		let mut rem = 0;
		if val_final * pow != s.value {
			rem = 1;
		}
		 if s.sign {
			if (rem == 1) && (val_final != 0){
				val_final -= 0;
			}
		}
		else {
			if (rem == 1) {
				val_final += 1;
			}
		}

		if n == 0 {
			return s;
		}
		else {
			let sn = Signed {
				sign: s.sign,
				value: val_final,
			};
			return sn;
		}
		
	}


}





mod tests{
	use super::SignedTrait;

	#[test]
	fn test_convert(){
		let s= SignedTrait::toSigned(true, 7);
		assert (s.value == 7, 'conversion test failed');
	}

	#[test]
	fn test_reverse(){
		let s= SignedTrait::toSigned(true, 7);
		let srev = SignedTrait::reverseSigned(s);
		assert (srev.value == 7, 'reversal test failed value');
		assert (srev.sign != s.sign, 'reversal test failed sign');
	}

	#[test]
	fn test_sum_signed(){
		let s1 = SignedTrait::toSigned(true, 5);
		let s2 = SignedTrait::toSigned(true, 8);
		let s = SignedTrait::addSigned(s1, s2);
		assert (s.value == 13, 'summation test failed');
	}


	#[test]
	fn test_sum_negative_signed(){
		let s1 = SignedTrait::toSigned(true, 5);
		let s2 = SignedTrait::toSigned(false, 8);
		let s = SignedTrait::addSigned(s1, s2);
		assert (s.value == 3, 'summation test failed');
	}

	#[test]
	fn test_diff_signed(){
		let s1 = SignedTrait::toSigned(true, 15);
		let s2 = SignedTrait::toSigned(true, 8);
		let s = SignedTrait::subtractSigned(s1, s2);
		assert (s.value == 7, 'difference test failed');
	}


	#[test]
	fn test_diff_negative_signed(){
		let s1 = SignedTrait::toSigned(true, 5);
		let s2 = SignedTrait::toSigned(false, 8);
		let s = SignedTrait::subtractSigned(s1, s2);
		assert (s.value == 13, 'difference test failed');
	}

	#[test]
	fn test_mul_signed(){
		let s1 = SignedTrait::toSigned(true, 5);
		let s2 = SignedTrait::toSigned(true, 8);
		let s = SignedTrait::multiplySigned(s1, s2);
		assert (s.value == 40, 'product test failed');
	}


	#[test]
	fn test_mul_negative_signed(){
		let s1 = SignedTrait::toSigned(true, 1);
		let s2 = SignedTrait::toSigned(false, 8);
		let s = SignedTrait::multiplySigned(s1, s2);
		assert (s.value == 8, 'product test failed value');
		assert (!s.sign, 'product test failed sign');
	}

	#[test]
	fn test_div_signed(){
		let s1 = SignedTrait::toSigned(true, 5);
		let s2 = SignedTrait::toSigned(true, 8);
		let s = SignedTrait::divideSigned(s1, s2);
		assert (s.value == 0, 'division test failed');
	}


	#[test]
	fn test_div_negative_signed(){
		let s1 = SignedTrait::toSigned(true, 16);
		let s2 = SignedTrait::toSigned(false, 8);
		let s = SignedTrait::divideSigned(s1, s2);
		assert (s.value == 2, 'division test failed value');
		assert (!s.sign, 'division test failed sign');
	}

	#[test]
	fn test_compare_signed1(){
		let s1 = SignedTrait::toSigned(true, 2);
		let s2 = SignedTrait::toSigned(false, 8);
		let cmp = SignedTrait::compareSigned(s1, s2);
		assert (cmp == 1, 'comparison test failed');
	}

	#[test]
	fn test_compare_signed2(){
		let s1 = SignedTrait::toSigned(false, 2);
		let s2 = SignedTrait::toSigned(true, 8);
		let cmp = SignedTrait::compareSigned(s1, s2);
		assert (cmp == 2, 'comparison test failed');
	}

	#[test]
	fn test_compare_signed0(){
		let s1 = SignedTrait::toSigned(true, 0);
		let s2 = SignedTrait::toSigned(false, 0);
		let cmp = SignedTrait::compareSigned(s1, s2);
		assert (cmp == 0, 'comparison test failed');
	}

	#[test]
	#[available_gas(1000000)]
	fn test_power1(){
		let s= SignedTrait::toSigned(false, 2);
		let spow = SignedTrait::powerSigned(s, 2);
		assert (spow.value == 4, 'power test failed value');
		assert (spow.sign != s.sign, 'power test failed sign');
	}

	#[test]
	#[available_gas(1000000)]
	fn test_power2(){
		let s= SignedTrait::toSigned(true, 3);
		let spow = SignedTrait::powerSigned(s, 3);
		assert (spow.value == 27, 'power test failed value');
		assert (spow.sign == s.sign, 'power test failed sign');
	}

	#[test]
	#[available_gas(1000000)]
	fn test_lshift_signed1(){
		let s1 = SignedTrait::toSigned(true, 6);
		
		let s = SignedTrait::leftShiftSigned(s1, 2);
		assert (s.value == 24, 'left shift test failed');
		
	}

	#[test]
	#[available_gas(1000000)]
	fn test_lshift_signed2(){
		let s1 = SignedTrait::toSigned(false, 6);
		
		let s = SignedTrait::leftShiftSigned(s1, 2);
		assert (s.value == 24, 'left shift test failed value');
		assert (!s.sign, 'left shift test failed sign');
	}

	#[test]
	#[available_gas(1000000)]
	fn test_rshift_signed1(){
		let s1 = SignedTrait::toSigned(true, 21);
		
		let s = SignedTrait::rightShiftSigned(s1, 2);
		assert (s.value == 5, 'right shift test failed');
		
	}

	#[test]
	#[available_gas(1000000)]
	fn test_rshift_signed2(){
		let s1 = SignedTrait::toSigned(false, 23);
		
		let s = SignedTrait::rightShiftSigned(s1, 3);
		assert (s.value == 3, 'right shift test failed value');
		assert (!s.sign, 'right shift test failed sign');
	}

}

