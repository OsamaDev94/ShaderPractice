// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderPractice/03Line"{
Properties{
	_Color ("Main Color", Color)=(1,1,1,1)
    _MainText("Main Texture", 2D) ="white" {} 
	_LineStart ("Line Start", float)= .5
	_LineWidth ("Line Width", float)=.3

}
SubShader{
	Tags{"Queue" ="Transparent" "IgnoreProjector" = "True" "RenderType"="Transparent" }

	Pass {
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#pragma vertex vert 
		#pragma fragment frag

		uniform half4 _Color;
        uniform sampler2D _MainText;
        uniform float4 _MainText_ST;
		uniform float _LineStart;
		uniform float _LineWidth;

		struct vertexInput{
			float4 vertex : POSITION;
            float4 texCord : TEXCOORD0;
		};

		struct vertexOutput {
			float4 pos : SV_POSITION;
            float4 texCord : TEXCOORD0;
		};

		vertexOutput vert (vertexInput v){
			vertexOutput o;
			o.pos=UnityObjectToClipPos(v.vertex);
            o.texCord.xy=(v.texCord.xy*_MainText_ST.xy+_MainText_ST.zw);
			return o;
		}	

		float DrawLine (float2 uv , float start , float end){
			if(uv.x>start && uv.x < end ){
				return 1;
			}
			else{
				return 0;
			}
		}
		half4 frag (vertexOutput i ): Color{
			float4 col = tex2D(_MainText,i.texCord)*_Color;
			col.a=DrawLine(i.texCord , _LineStart,_LineStart+_LineWidth) ;
			return col;
		}

		ENDCG
	}
}
}
