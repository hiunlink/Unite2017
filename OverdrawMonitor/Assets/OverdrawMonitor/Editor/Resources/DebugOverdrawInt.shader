// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Debug/OverdrawInt"
{
	Properties
	{
		[Header(Hardware settings)]
		[Enum(UnityEngine.Rendering.CullMode)] HARDWARE_CullMode ("Cull faces", Float) = 2
		[Enum(On, 1, Off, 0)] HARDWARE_ZWrite ("Depth write", Float) = 1
		[Enum(Opaque, 1, Transparent, 0)] RenderType ("Render Type", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry+50"}
		LOD 100
		
		Pass
		{
			Cull [HARDWARE_CullMode]
			ZWrite [HARDWARE_ZWrite]
			Blend One One
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			//#pragma exclude_renderers d3d11_9x

			float RenderType;

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
				// 1 / 512 = 0.001953125; 1 / 1024 = 0.0009765625
				float val = 0.0009765625;
				//float val =  0.01; // For debug
				if (RenderType == 1)
					return float4(val, 0, 0, 0);
				else
					return float4(0, val, 0, 0);
			}
			ENDCG
		}
	}
}
